import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:moniman/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.displayName,
    required super.phoneNumber,
    super.email,
    super.photoUrl,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName ?? '',
      phoneNumber: user.phoneNumber ?? '',
      email: user.email,
      photoUrl: user.photoURL,
    );
  }
}
