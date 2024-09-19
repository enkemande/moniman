import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthException extends Equatable implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  List<Object?> get props => [message];
}

class UserException extends Equatable implements Exception {
  final String message;

  const UserException(this.message);

  @override
  List<Object?> get props => [message];
}

class AccountException extends Equatable implements Exception {
  final String message;

  const AccountException(this.message);

  @override
  List<Object?> get props => [message];
}

class OnboardingStepException extends Equatable implements Exception {
  final String message;

  const OnboardingStepException(this.message);

  @override
  List<Object?> get props => [message];
}

class DepositException extends Equatable implements Exception {
  final String message;

  const DepositException(this.message);

  @override
  List<Object?> get props => [message];
}

class WithdrawException extends Equatable implements Exception {
  final String message;

  const WithdrawException(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentException extends Equatable implements Exception {
  final String message;

  const PaymentException(this.message);

  @override
  List<Object?> get props => [message];
}
