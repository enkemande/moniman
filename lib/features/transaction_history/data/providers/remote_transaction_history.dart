import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/core/utils/aes_encryption.dart';
import 'package:moniman/core/utils/rsa_encryption.dart';
import 'package:moniman/core/utils/secure_storage.dart';
import 'package:moniman/features/transaction_history/data/models/transaction_history.dart';
import 'package:moniman/features/transaction_history/domain/entities/transaction_history.dart';

abstract class RemoteTransactionHistoryProvider {
  Stream<List<TransactionHistory>> listenToTransactionHistoryChanges(
    String userId,
  );
}

class RemoteTransactionHistoryProviderImpl
    implements RemoteTransactionHistoryProvider {
  final _firestore = FirebaseFirestore.instance;
  final RsaEncryption rsaEncryption;
  final AesEncryption aesEncryption;
  final SecureStorage secureStorage;

  RemoteTransactionHistoryProviderImpl({
    required this.rsaEncryption,
    required this.aesEncryption,
    required this.secureStorage,
  });

  @override
  Stream<List<TransactionHistory>> listenToTransactionHistoryChanges(
    String userId,
  ) async* {
    final privateKey = await secureStorage.getPrivateKey();
    final collection = _firestore.collection('transactions');
    final query = collection
        .where('participantUserIds', arrayContains: userId)
        .limit(15)
        .orderBy('createdAt', descending: true);

    yield* query.snapshots().map((snapshot) {
      return snapshot.docs.where((doc) => doc.exists).map((doc) {
        final data = doc.data();
        final transDecryptedKey = rsaEncryption.decryptMessage(
          data['decryptKey'],
          rsaEncryption.parsePrivateKeyFromPem(privateKey),
        );
        data['id'] = doc.id;
        data['amount'] = int.parse(aesEncryption.decryptMessage(
          data['encryptedAmount'],
          aesEncryption.parseKeyFromEncoded(transDecryptedKey),
        ));
        return TransactionHistoryModel.fromMap(data);
      }).toList();
    });
  }
}
