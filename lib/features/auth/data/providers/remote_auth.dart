import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/features/auth/data/models/session.dart';
import 'package:moniman/features/auth/domain/entities/session.dart';

abstract class RemoteAuthProvider {
  Stream<Session?> onAuthStateChanged();
  Future<String> verifyPhoneNumber({
    required String phoneNumber,
    Function(Session)? verificationCompleted,
  });
  Future<Session> verifyOtp({
    required String code,
    required String verificationId,
  });
  Future<void> signOut();
}

class RemoteAuthProviderImpl implements RemoteAuthProvider {
  final _auth = firebase_auth.FirebaseAuth.instance;

  @override
  Future<String> verifyPhoneNumber({
    required String phoneNumber,
    Function(Session)? verificationCompleted,
  }) async {
    try {
      final completer = Completer<String>();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          verificationCompleted?.call(
            SessionModel(uid: userCredential.user?.uid),
          );
        },
        verificationFailed: (error) {
          completer.completeError(error);
        },
        codeSent: (verificationId, resendToken) {
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          completer.complete(verificationId);
        },
      );
      final result = await completer.future;
      return result;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message!);
    }
  }

  @override
  Future<Session> verifyOtp({
    required String code,
    required String verificationId,
  }) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return SessionModel(uid: userCredential.user?.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message!);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message!);
    }
  }

  @override
  Stream<Session?> onAuthStateChanged() {
    return _auth.authStateChanges().map((user) {
      return user == null ? null : SessionModel(uid: user.uid);
    });
  }
}
