import 'package:moniman/features/transactions/data/providers/remote_transaction.dart';
import 'package:moniman/features/transactions/domain/entities/transaction.dart';
import 'package:moniman/features/transactions/domain/repositories/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final RemoteTransactionProvider remoteTransactionProvider;

  TransactionRepositoryImpl({
    required this.remoteTransactionProvider,
  });

  @override
  Stream<List<Transaction>> onTransactionsChange({required String userId}) {
    return remoteTransactionProvider.onTransactionsChange(userId: userId);
  }
}
