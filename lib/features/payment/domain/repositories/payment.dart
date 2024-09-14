import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> pay({
    required String accountId,
    required int amount,
    String? paymentMethodId,
  });

  Future<Either<Failure, void>> request({
    required String accountId,
    required int amount,
  });
}
