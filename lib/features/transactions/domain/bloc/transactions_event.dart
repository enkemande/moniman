part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

final class TransactionsChangedEvent extends TransactionsEvent {
  final List<Transaction> transactions;

  const TransactionsChangedEvent(this.transactions);

  @override
  List<Object> get props => [transactions];
}
