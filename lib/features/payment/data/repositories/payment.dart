import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/payment/data/providers/remote_payment.dart';
import 'package:moniman/features/payment/domain/repositories/payment.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final RemotePaymentProvider remotePaymentProvider;

  PaymentRepositoryImpl({
    required this.remotePaymentProvider,
  });

  @override
  Future<Either<Failure, void>> pay({
    required String accountId,
    required int amount,
    String? paymentMethodId,
  }) async {
    try {
      await remotePaymentProvider.pay(
        accountId: accountId,
        amount: amount,
        paymentMethodId: paymentMethodId,
      );
      return const Right(null);
    } on PaymentException catch (e) {
      return Left(PaymentFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> request({
    required String accountId,
    required int amount,
  }) async {
    try {
      await remotePaymentProvider.request(
        accountId: accountId,
        amount: amount,
      );
      return const Right(null);
    } on PaymentException catch (e) {
      return Left(PaymentFailure(e.message));
    }
  }
}
