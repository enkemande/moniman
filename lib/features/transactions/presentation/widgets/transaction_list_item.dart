import 'package:flutter/material.dart';
import 'package:moniman/features/transactions/domain/entities/transaction.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final Function() onTap;
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.green[100],
        child: const Icon(Icons.money),
      ),
      title: Text(transaction.title),
      subtitle: Text(transaction.description),
      trailing: Text(
        transaction.amount.toString(),
        style: TextStyle(
          color: transaction.amount > 0 ? Colors.green : Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
