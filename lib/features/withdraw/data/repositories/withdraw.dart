import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/withdraw/data/providers/remote_withdraw.dart';
import 'package:moniman/features/withdraw/domain/repositories/withdraw.dart';

class WithdrawRepositoryImpl implements WithdrawRepository {
  final RemoteWithdrawProvider remoteWithdrawProvider;

  WithdrawRepositoryImpl({
    required this.remoteWithdrawProvider,
  });

  @override
  Future<Either<Failure, void>> withdraw({
    required double amount,
    required String userId,
    required String paymentMethodId,
  }) async {
    try {
      await remoteWithdrawProvider.withdraw(
        amount: amount,
        userId: userId,
        paymentMethodId: paymentMethodId,
      );
      return const Right(null);
    } on WithdrawException catch (e) {
      return Left(WithdrawFailure(e.message));
    }
  }
}
