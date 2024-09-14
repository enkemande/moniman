import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';

abstract class DepositRepository {
  Future<Either<Failure, void>> deposit({
    required String userId,
    required String paymentMethodId,
    required int amount,
  });
}
