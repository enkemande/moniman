import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';

abstract class WithdrawRepository {
  Future<Either<Failure, void>> withdraw({
    required double amount,
    required String userId,
    required String paymentMethodId,
  });
}
