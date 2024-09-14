import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Stream<User?> onUserChange({required String userId});
  Future<Either<Failure, void>> updateUser(User user);
  Future<Either<Failure, User>> getUser({required String userId});
}
