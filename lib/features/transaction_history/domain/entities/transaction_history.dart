import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:moniman/core/enums/currencies.dart';
import 'package:moniman/core/extensions/currency.dart';

class TransactionHistory extends Equatable {
  final String id;
  final String sourceId;
  final int amount;
  final String title;
  final Currencies currency;
  final String status;
  final String type;
  final String? destinationId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TransactionHistory({
    required this.id,
    required this.sourceId,
    required this.amount,
    required this.title,
    required this.type,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.destinationId,
  });

  String get formattedBalance {
    final formattedAmount = NumberFormat.currency(
      locale: 'en_US',
      customPattern: '#,### \u00a4',
      symbol: currency.symbol,
      decimalDigits: 0,
    ).format(amount);

    if (type == 'deposit') {
      return '+$formattedAmount';
    }

    return formattedAmount;
  }

  String get formattedDate {
    return DateFormat.yMMMd().format(createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        sourceId,
        amount,
        currency,
        type,
        status,
        title,
        destinationId,
        updatedAt,
        createdAt
      ];
}
