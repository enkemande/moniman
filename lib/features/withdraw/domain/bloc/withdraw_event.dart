part of 'withdraw_bloc.dart';

sealed class WithdrawEvent extends Equatable {
  const WithdrawEvent();

  @override
  List<Object> get props => [];
}

class WithdrawRequestEvent extends WithdrawEvent {
  final double amount;
  final String accountId;
  final String paymentMethodId;

  const WithdrawRequestEvent({
    required this.amount,
    required this.accountId,
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [amount, accountId, paymentMethodId];
}
