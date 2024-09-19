import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String phoneNumber;
  final String displayName;
  final String? email;
  final String? photoUrl;

  const User({
    required this.uid,
    required this.displayName,
    required this.phoneNumber,
    this.email,
    this.photoUrl,
  });

  static const empty = User(
    uid: '',
    displayName: '',
    phoneNumber: '',
  );

  bool get isEmpty {
    return uid.isEmpty && phoneNumber.isEmpty;
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        phoneNumber,
        displayName,
        photoUrl,
      ];
}
