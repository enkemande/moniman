import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final String currency;
  final String status;
  final String type;
  final String title;
  final String description;

  const Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.type,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        amount,
        currency,
        status,
        type,
        title,
        description,
      ];
}
