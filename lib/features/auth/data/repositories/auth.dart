import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/auth/data/providers/remote_auth.dart';
import 'package:moniman/features/auth/domain/entities/session.dart';
import 'package:moniman/features/auth/domain/repositories/auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthProvider remoteAuthProvider;

  AuthRepositoryImpl({
    required this.remoteAuthProvider,
  });

  @override
  Stream<Session?> onAuthStateChanged() {
    return remoteAuthProvider.onAuthStateChanged();
  }

  @override
  Future<Either<Failure, String>> verifyPhoneNumber({
    required String phoneNumber,
    Function(Session)? verificationCompleted,
  }) async {
    try {
      final verificationId = await remoteAuthProvider.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (session) {
          verificationCompleted?.call(session);
        },
      );
      return Right(verificationId);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Session>> verifyOtp({
    required String code,
    required String verificationId,
  }) async {
    try {
      final session = await remoteAuthProvider.verifyOtp(
        code: code,
        verificationId: verificationId,
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
