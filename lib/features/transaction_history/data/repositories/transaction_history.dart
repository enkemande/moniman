import 'package:moniman/features/transaction_history/data/providers/remote_transaction_history.dart';
import 'package:moniman/features/transaction_history/domain/entities/transaction_history.dart';
import 'package:moniman/features/transaction_history/domain/repositories/transaction_history.dart';

class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {
  final RemoteTransactionHistoryProvider remoteTransactionHistoryProvider;

  TransactionHistoryRepositoryImpl({
    required this.remoteTransactionHistoryProvider,
  });

  @override
  Stream<List<TransactionHistory>> listenToTransactionHistoryChanges(
    String userId,
  ) {
    return remoteTransactionHistoryProvider.listenToTransactionHistoryChanges(
      userId,
    );
  }
}
