import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/auth/data/providers/remote_auth.dart';
import 'package:moniman/features/auth/domain/entities/user.dart';
import 'package:moniman/features/auth/domain/repositories/auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthProvider remoteAuthProvider;

  AuthRepositoryImpl({
    required this.remoteAuthProvider,
  });

  @override
  Stream<User> onAuthStateChanged() {
    return remoteAuthProvider.onAuthStateChanged();
  }

  @override
  Future<Either<Failure, T>> verifyPhoneNumber<T>({
    required String phoneNumber,
  }) async {
    try {
      final result = await remoteAuthProvider.verifyPhoneNumber(
        phoneNumber: phoneNumber,
      );
      return Right(result);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String code,
    required String verificationId,
  }) async {
    try {
      final session = await remoteAuthProvider.verifyOtp(
        verificationId: verificationId,
        code: code,
      );
      return Right(session);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteAuthProvider.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
