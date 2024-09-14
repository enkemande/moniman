import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/transactions/domain/bloc/transactions_bloc.dart';
import 'package:moniman/features/transactions/presentation/widgets/transaction_list_item.dart';

class RecentTransactionsCard extends StatelessWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state is TransactionsLoaded) {
          final transactions = state.transactions.take(5).toList();
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Transactions'),
                    ],
                  ),
                ),
                // const Divider(height: 0.1, thickness: 0.1),
                for (var transaction in transactions)
                  TransactionListItem(
                    transaction: transaction,
                    onTap: () {},
                  )
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
