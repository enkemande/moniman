import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class AccountFailure extends Failure {
  const AccountFailure(super.message);
}

class OnboardingStepFailure extends Failure {
  const OnboardingStepFailure(super.message);
}

class DepositFailure extends Failure {
  const DepositFailure(super.message);
}

class WithdrawFailure extends Failure {
  const WithdrawFailure(super.message);
}

class PaymentFailure extends Failure {
  const PaymentFailure(super.message);
}
