part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthOtpSent extends AuthState {
  final String verificationId;

  const AuthOtpSent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

final class Authenticated extends AuthState {
  final Session session;

  const Authenticated(this.session);

  @override
  List<Object> get props => [session];
}

final class Unauthenticated extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
