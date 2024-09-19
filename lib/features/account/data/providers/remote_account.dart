import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/utils/rsa_encryption.dart';
import 'package:moniman/core/utils/secure_storage.dart';
import 'package:moniman/features/account/data/models/account.dart';
import 'package:moniman/features/account/domain/entities/account.dart';

abstract class RemoteAccountProvider {
  Stream<Account> onAccountStateChange(String userId);
  Future<void> createAccount(Account account);
  Future<void> updateAccount(Account account);
  Future<void> deleteAccount(String id);
  Future<int> decryptBalance(String encryptedBalance);
  Future<String> encryptBalance(int balance);
}

class RemoteAccountProviderImpl implements RemoteAccountProvider {
  final _firestore = FirebaseFirestore.instance;
  final SecureStorage secureStorage;
  final RsaEncryption rsaEncryption;

  RemoteAccountProviderImpl({
    required this.secureStorage,
    required this.rsaEncryption,
  });

  @override
  Stream<Account> onAccountStateChange(String userId) async* {
    final snapshots = _firestore.collection('accounts').doc(userId).snapshots();
    await for (var snapshot in snapshots) {
      if (!snapshot.exists) {
        yield Account.empty();
      } else {
        final privateKeyPem = await secureStorage.getPrivateKey();
        final data = snapshot.data();
        data!['id'] = snapshot.id;
        data['decryptedBalance'] = rsaEncryption.decryptMessage(
          data['encryptedBalance'],
          rsaEncryption.parsePrivateKeyFromPem(privateKeyPem),
        );
        yield AccountModel.fromMap(data);
      }
    }
  }

  @override
  Future<void> createAccount(Account account) async {
    try {
      await _firestore
          .collection('accounts')
          .doc(account.id)
          .set(AccountModel.fromEntity(account).toCreateMap());
    } on FirebaseException catch (error) {
      throw AccountException(error.message ?? 'An error occurred');
    }
  }

  @override
  Future<void> updateAccount(Account account) async {
    try {
      await _firestore
          .collection('accounts')
          .doc(account.id)
          .update(AccountModel.fromEntity(account).toUpdateMap());
    } on FirebaseException catch (error) {
      throw AccountException(error.message ?? 'An error occurred');
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    try {
      await _firestore.collection('accounts').doc(id).delete();
    } on FirebaseException catch (error) {
      throw AccountException(error.message ?? 'An error occurred');
    }
  }

  @override
  Future<int> decryptBalance(String encryptedBalance) async {
    final privateKeyPem = await secureStorage.getPrivateKey();
    return int.parse(rsaEncryption.decryptMessage(
      encryptedBalance,
      rsaEncryption.parsePrivateKeyFromPem(privateKeyPem),
    ));
  }

  @override
  Future<String> encryptBalance(int balance) async {
    final publicKeyPem = await secureStorage.getPublicKey();
    return rsaEncryption.encryptMessage(
      balance.toString(),
      rsaEncryption.parsePublicKeyFromPem(publicKeyPem),
    );
  }
}
