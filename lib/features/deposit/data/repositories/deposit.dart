import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/deposit/data/providers/remote_deposit.dart';
import 'package:moniman/features/deposit/domain/repositories/deposit.dart';

class DepositRepositoryImpl implements DepositRepository {
  final RemoteDepositProvider remoteDepositProvider;

  DepositRepositoryImpl({
    required this.remoteDepositProvider,
  });

  @override
  Future<Either<Failure, void>> deposit({
    required String userId,
    required String paymentMethodId,
    required int amount,
  }) async {
    try {
      await remoteDepositProvider.deposit(
        userId: userId,
        paymentMethodId: paymentMethodId,
        amount: amount,
      );
      return const Right(null);
    } on DepositException catch (e) {
      return Left(DepositFailure(e.message));
    }
  }
}
