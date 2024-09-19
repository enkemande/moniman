import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/utils/aes_encryption.dart';
import 'package:moniman/core/utils/rsa_encryption.dart';
import 'package:moniman/core/utils/secure_storage.dart';

abstract class RemoteDepositProvider {
  Future<void> deposit({
    required String userId,
    required String paymentMethodId,
    required int amount,
  });
}

class RemoteDepositProviderImpl implements RemoteDepositProvider {
  final _firestore = FirebaseFirestore.instance;
  final RsaEncryption rsaEncryption;
  final SecureStorage secureStorage;
  final AesEncryption aesEncryption;

  RemoteDepositProviderImpl({
    required this.rsaEncryption,
    required this.secureStorage,
    required this.aesEncryption,
  });

  @override
  Future<void> deposit({
    required String userId,
    required String paymentMethodId,
    required int amount,
  }) async {
    final accountRef = _firestore.collection('accounts').doc(userId);
    final transactionRef = _firestore.collection('transactions').doc();

    try {
      await _firestore.runTransaction((transaction) async {
        final privateKey = await secureStorage.getPrivateKey();
        final publicKey = await secureStorage.getPublicKey();

        final accountDoc = await transaction.get(accountRef);
        if (!accountDoc.exists) throw "User does not exist!";
        final account = accountDoc.data() as Map<String, dynamic>;

        final decryptedBalance = int.parse(
          rsaEncryption.decryptMessage(
            account['encryptedBalance'],
            rsaEncryption.parsePrivateKeyFromPem(privateKey),
          ),
        );

        final newBalance = decryptedBalance + amount;
        final encryptedBalance = rsaEncryption.encryptMessage(
          newBalance.toString(),
          rsaEncryption.parsePublicKeyFromPem(publicKey),
        );

        final transactionEncryptionKey = aesEncryption.generateRandomKey();

        final encryptedAmount = aesEncryption.encryptMessage(
          amount.toString(),
          transactionEncryptionKey,
        );

        final encryptedTransactionDecryptKey = rsaEncryption.encryptMessage(
          transactionEncryptionKey.base64,
          rsaEncryption.parsePublicKeyFromPem(publicKey),
        );

        // process payment

        transaction.set(transactionRef, {
          'sourceId': userId,
          'encryptedAmount': encryptedAmount,
          'decryptKey': encryptedTransactionDecryptKey,
          'type': 'deposit',
          'title': 'Deposit',
          'status': 'completed',
          'currency': account['currency'],
          'participantUserIds': [userId],
          'createdAt': FieldValue.serverTimestamp(),
        });

        transaction.update(accountRef, {
          'encryptedBalance': encryptedBalance,
        });
      });
    } on FirebaseException catch (error) {
      throw DepositException(error.message ?? 'An error occurred');
    }
  }
}
