import 'package:cloud_functions/cloud_functions.dart';
import 'package:moniman/core/errors/exceptions.dart';

abstract class RemotePaymentProvider {
  Future<void> pay({
    required String accountId,
    required int amount,
    String? paymentMethodId,
  });

  Future<void> request({
    required String accountId,
    required int amount,
  });
}

class RemotePaymentProviderImpl implements RemotePaymentProvider {
  final _functions = FirebaseFunctions.instance;

  @override
  Future<void> pay({
    required String accountId,
    required int amount,
    String? paymentMethodId,
  }) async {
    try {
      await _functions.httpsCallable('sendMoney').call({
        'accountId': accountId,
        'amount': amount,
        'paymentMethodId': paymentMethodId,
      });
    } on FirebaseFunctionsException catch (e) {
      throw PaymentException(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<void> request({
    required String accountId,
    required int amount,
  }) async {
    try {
      await _functions.httpsCallable('requestPayment').call({
        'accountId': accountId,
        'amount': amount,
      });
    } on FirebaseFunctionsException catch (e) {
      throw PaymentException(e.message ?? 'An error occurred');
    }
  }
}
