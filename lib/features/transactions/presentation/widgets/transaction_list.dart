import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/transactions/domain/bloc/transactions_bloc.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state is TransactionsLoaded) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return ListTile(
                subtitle: Text(transaction.amount.toString()),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
