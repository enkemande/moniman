import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Stream<User> onAuthStateChanged();
  Future<Either<Failure, T>> verifyPhoneNumber<T>({
    required String phoneNumber,
  });
  Future<Either<Failure, User>> verifyOtp({
    required String code,
    required String verificationId,
  });
  Future<Either<Failure, void>> signOut();
}
