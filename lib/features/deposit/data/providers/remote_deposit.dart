import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/features/user/data/models/user.dart';

abstract class RemoteDepositProvider {
  Future<void> deposit({
    required String userId,
    required String paymentMethodId,
    required int amount,
  });
}

class RemoteDepositProviderImpl implements RemoteDepositProvider {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> deposit({
    required String userId,
    required String paymentMethodId,
    required int amount,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);
    final transactionRef =
        _firestore.doc(userId).collection('transactions').doc();

    try {
      if (amount <= 0) throw 'Amount must be greater than 0!';
      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        if (!userDoc.exists) throw "User does not exist!";
        final user = UserModel.fromDocSnapshot(userDoc);

        if (user.status != 'active') throw "User is not active!";
        final newBalance = user.balance + amount;

        transaction.update(userRef, {
          'balance': newBalance,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // process payment here

        transaction.set(transactionRef, {
          'userId': userId,
          'paymentMethodId': paymentMethodId,
          'amount': amount,
          'type': 'deposit',
          'status': 'completed',
          'title': 'Deposit',
          'description': 'Deposit to account',
          'currency': user.currency,
          'createdAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (error) {
      throw DepositException(error.message ?? 'An error occurred');
    }
  }
}
