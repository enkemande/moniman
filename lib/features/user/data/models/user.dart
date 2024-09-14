import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/features/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.balance,
    required super.currency,
    required super.status,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      balance: map['balance'],
      currency: map['currency'],
      status: map['status'],
    );
  }

  factory UserModel.fromDocSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    return UserModel.fromMap(data);
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      balance: user.balance,
      currency: user.currency,
      status: user.status,
    );
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'balance': balance,
      'currency': currency,
      'status': status,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      balance: balance,
      currency: currency,
      status: status,
    );
  }
}
