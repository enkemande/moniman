import 'package:moniman/features/transaction_history/domain/entities/transaction_history.dart';

abstract class TransactionHistoryRepository {
  Stream<List<TransactionHistory>> listenToTransactionHistoryChanges(
    String userId,
  );
}
