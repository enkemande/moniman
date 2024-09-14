import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:moniman/features/transactions/data/models/transaction.dart';
import 'package:moniman/features/transactions/domain/entities/transaction.dart';

abstract class RemoteTransactionProvider {
  Stream<List<Transaction>> onTransactionsChange({required String userId});
}

class RemoteTransactionProviderImpl implements RemoteTransactionProvider {
  final _firestore = firestore.FirebaseFirestore.instance;

  @override
  Stream<List<Transaction>> onTransactionsChange({required String userId}) {
    return _firestore
        .collection('transactions')
        .doc(userId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(15)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }).toList();
    });
  }
}
