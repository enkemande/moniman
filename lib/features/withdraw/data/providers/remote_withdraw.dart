import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:moniman/core/errors/exceptions.dart';

abstract class RemoteWithdrawProvider {
  Future<void> withdraw({
    required double amount,
    required String userId,
    required String paymentMethodId,
  });
}

class RemoteWithdrawProviderImpl implements RemoteWithdrawProvider {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> withdraw({
    required double amount,
    required String userId,
    required String paymentMethodId,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);
    final transactionRef = _firestore.collection('transactions').doc();

    try {
      if (amount <= 0) throw 'Amount must be greater than 0!';
      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        if (!userDoc.exists) throw "User does not exist!";
        final user = userDoc.data() as Map<String, dynamic>;

        if (user['status'] != 'active') throw "User is not active!";
        final newBalance = user['balance'] - amount;

        if (newBalance < 0) throw "Insufficient balance!";

        transaction.update(userRef, {
          'balance': newBalance,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // process payment here

        transaction.set(transactionRef, {
          'userId': userId,
          'paymentMethodId': paymentMethodId,
          'amount': amount,
          'type': 'withdraw',
          'status': 'completed',
          'createdAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseFunctionsException catch (e) {
      throw WithdrawException(e.message ?? 'An error occurred');
    }
  }
}
