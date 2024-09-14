import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/user/data/models/user.dart';
import 'package:moniman/features/user/data/providers/remote_user.dart';
import 'package:moniman/features/user/domain/entities/user.dart';
import 'package:moniman/features/user/domain/repositories/user.dart';

class UserRepositoryImpl extends UserRepository {
  final RemoteUserProvider remoteUserProvider;

  UserRepositoryImpl({required this.remoteUserProvider});

  @override
  Stream<User?> onUserChange({required String userId}) {
    return remoteUserProvider.onUserChange(userId: userId);
  }

  @override
  Future<Either<Failure, User>> getUser({required String userId}) async {
    try {
      final user = await remoteUserProvider.getUser(userId: userId);
      return Right(user);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      await remoteUserProvider.updateUser(UserModel.fromEntity(user));
      return const Right(null);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }
}
