import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final int balance;
  final String currency;
  final String status;
  final String? photoUrl;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.balance,
    required this.currency,
    required this.status,
    this.photoUrl,
  });

  String get legalName => '$firstName $lastName';

  String get formattedBalance {
    return '$balance $currency';
  }

  // copyWith method
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    int? balance,
    String? currency,
    String? status,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        balance,
        currency,
        status,
        photoUrl,
        formattedBalance
      ];
}
