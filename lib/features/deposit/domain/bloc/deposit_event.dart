part of 'deposit_bloc.dart';

sealed class DepositEvent extends Equatable {
  const DepositEvent();

  @override
  List<Object> get props => [];
}

class DepositRequestEvent extends DepositEvent {
  final int amount;
  final String paymentMethodId;

  const DepositRequestEvent({
    required this.amount,
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [amount, paymentMethodId];
}
