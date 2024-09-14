part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class SendMoneyPaymentEvent extends PaymentEvent {
  final int amount;
  final String accountId;
  final String paymentMethodId;

  const SendMoneyPaymentEvent({
    required this.amount,
    required this.accountId,
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [amount, accountId, paymentMethodId];
}

class RequestPaymentEvent extends PaymentEvent {
  final int amount;
  final String accountId;

  const RequestPaymentEvent({
    required this.amount,
    required this.accountId,
  });

  @override
  List<Object> get props => [amount, accountId];
}
