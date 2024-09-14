part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStateChangeEvent extends AuthEvent {
  final Session? session;

  const AuthStateChangeEvent(this.session);

  @override
  List<Object> get props => [];
}

class VerifyPhoneNumberEvent extends AuthEvent {
  final String phoneNumber;

  const VerifyPhoneNumberEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String code;
  final String verificationId;

  const VerifyOtpEvent({
    required this.code,
    required this.verificationId,
  });

  @override
  List<Object> get props => [code, verificationId];
}

class SignOutEvent extends AuthEvent {}
