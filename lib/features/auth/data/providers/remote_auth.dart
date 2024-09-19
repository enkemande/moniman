import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/utils/rsa_encryption.dart';
import 'package:moniman/core/utils/secure_storage.dart';
import 'package:moniman/features/account/data/providers/remote_account.dart';
import 'package:moniman/features/account/domain/entities/account.dart';
import 'package:moniman/features/auth/data/models/user.dart';
import 'package:moniman/features/auth/domain/entities/user.dart';
import 'package:moniman/features/onboarding/data/providers/remote_onboarding.dart';

abstract class RemoteAuthProvider {
  Stream<User> onAuthStateChanged();
  Future<T> verifyPhoneNumber<T>({required String phoneNumber});
  Future<User> signInWithCredential(firebase_auth.AuthCredential credential);
  Future<User> verifyOtp({
    required String code,
    required String verificationId,
  });
  Future<void> signOut();
}

class RemoteAuthProviderImpl implements RemoteAuthProvider {
  final _auth = firebase_auth.FirebaseAuth.instance;

  final RsaEncryption rsaEncryption;
  final RemoteAccountProvider remoteAccountProvider;
  final RemoteOnboardingProvider remoteOnboardingProvider;
  final SecureStorage secureStorage;

  RemoteAuthProviderImpl({
    required this.rsaEncryption,
    required this.remoteAccountProvider,
    required this.remoteOnboardingProvider,
    required this.secureStorage,
  });

  @override
  Stream<User> onAuthStateChanged() async* {
    yield* _auth.authStateChanges().map((user) {
      if (user == null) return User.empty;
      return UserModel.fromFirebaseUser(user);
    });
  }

  @override
  Future<T> verifyPhoneNumber<T>({
    required String phoneNumber,
  }) async {
    try {
      final completer = Completer<T>();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          final user = await signInWithCredential(credential);
          completer.complete(user as T);
        },
        verificationFailed: (error) {
          completer.completeError(error);
        },
        codeSent: (verificationId, resendToken) {
          completer.complete(verificationId as T);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          completer.complete(verificationId as T);
        },
      );
      final result = await completer.future;
      return result;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message!);
    }
  }

  @override
  Future<User> verifyOtp({
    required String code,
    required String verificationId,
  }) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      return signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      signOut();
      throw AuthException(e.message!);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<User> signInWithCredential(
    firebase_auth.AuthCredential credential,
  ) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final userId = userCredential.user!.uid;
        final phoneNumber = userCredential.user!.phoneNumber!;
        final encryptionKeyPair = rsaEncryption.generateRSAKeyPair();
        final publicKey = encryptionKeyPair.publicKey;
        final privateKey = encryptionKeyPair.privateKey;
        final publicKeyPem = rsaEncryption.encodePublicKeyToPem(publicKey);
        final privateKeyPem = rsaEncryption.encodePrivateKeyToPem(privateKey);

        await remoteAccountProvider.createAccount(Account(
          id: userId,
          encryptedBalance: rsaEncryption.encryptMessage('0', publicKey),
          phoneNumber: phoneNumber,
          publicKey: publicKeyPem,
        ));

        await remoteOnboardingProvider.initOnboardingSteps(userId: userId);
        await secureStorage.storePrivateKey(privateKeyPem);
        await secureStorage.storePublicKey(publicKeyPem);
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message!);
    }
  }
}
