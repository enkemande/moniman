import 'package:moniman/features/transactions/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.status,
    required super.type,
    required super.title,
    required super.description,
    required super.currency,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      currency: json['currency'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      type: json['type'],
    );
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      amount: transaction.amount,
      currency: transaction.currency,
      title: transaction.title,
      description: transaction.description,
      status: transaction.status,
      type: transaction.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'userId': super.userId,
      'amount': super.amount,
      'title': super.title,
      'description': super.description,
      'currency': super.currency,
      'status': super.status,
      'type': super.type,
    };
  }
}
