import 'package:flutter/material.dart';
import 'package:moniman/features/transaction_history/domain/entities/transaction_history.dart';

class TransactionHistoryListItem extends StatelessWidget {
  final TransactionHistory transactionHistory;
  final Function() onTap;
  const TransactionHistoryListItem({
    super.key,
    required this.transactionHistory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.cast_sharp),
      ),
      title: Text(transactionHistory.title),
      subtitle: Text(
        transactionHistory.formattedDate,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transactionHistory.formattedBalance,
            style: TextStyle(
              color: transactionHistory.amount > 0 ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
