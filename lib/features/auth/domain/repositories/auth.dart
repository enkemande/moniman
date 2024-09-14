import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/auth/domain/entities/session.dart';

abstract class AuthRepository {
  Stream<Session?> onAuthStateChanged();
  Future<Either<Failure, String>> verifyPhoneNumber({
    required String phoneNumber,
    Function(Session)? verificationCompleted,
  });
  Future<Either<Failure, Session>> verifyOtp({
    required String code,
    required String verificationId,
  });
  Future<Either<Failure, void>> signOut();
}
