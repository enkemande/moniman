part of 'transaction_history_bloc.dart';

sealed class TransactionHistoryState extends Equatable {
  const TransactionHistoryState();

  @override
  List<Object> get props => [];
}

final class TransactionHistoryInitial extends TransactionHistoryState {}

final class TransactionHistoriesLoaded extends TransactionHistoryState {
  final List<TransactionHistory> transactionHistories;

  const TransactionHistoriesLoaded(this.transactionHistories);

  @override
  List<Object> get props => [transactionHistories];
}
