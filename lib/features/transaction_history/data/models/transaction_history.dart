import 'package:moniman/core/enums/currencies.dart';
import 'package:moniman/features/transaction_history/domain/entities/transaction_history.dart';

class TransactionHistoryModel extends TransactionHistory {
  const TransactionHistoryModel({
    required super.id,
    required super.sourceId,
    required super.amount,
    required super.currency,
    required super.status,
    required super.type,
    required super.title,
    required super.createdAt,
  });

  factory TransactionHistoryModel.fromMap(Map<String, dynamic> map) {
    return TransactionHistoryModel(
      id: map['id'],
      sourceId: map['sourceId'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      currency: Currencies.values.firstWhere(
        (e) => e.toString() == 'Currencies.${map['currency']}',
      ),
      status: map['status'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}
