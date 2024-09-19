part of 'transaction_history_bloc.dart';

sealed class TransactionHistoryEvent extends Equatable {
  const TransactionHistoryEvent();

  @override
  List<Object> get props => [];
}

class TransactionHistoriesChanged extends TransactionHistoryEvent {
  final List<TransactionHistory> transactionHistories;

  const TransactionHistoriesChanged(this.transactionHistories);

  @override
  List<Object> get props => [transactionHistories];
}
