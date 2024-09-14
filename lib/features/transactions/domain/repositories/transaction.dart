import 'package:moniman/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> onTransactionsChange({required String userId});
}
