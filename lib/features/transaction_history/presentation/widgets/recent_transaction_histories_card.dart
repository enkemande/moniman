import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/core/presentation/theme/app_color.dart';
import 'package:moniman/features/transaction_history/domain/bloc/transaction_history_bloc.dart';
import 'package:moniman/features/transaction_history/presentation/widgets/transaction_history_list_item.dart';

class RecentTransactionHistoriesCard extends StatelessWidget {
  const RecentTransactionHistoriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        if (state is TransactionHistoriesLoaded) {
          final recentTransactionHistories = state.transactionHistories.take(5);
          if (recentTransactionHistories.isEmpty) {
            return const SizedBox.shrink();
          }
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        'Transactions Histories',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 0, thickness: 0.2, color: Colors.grey),
                ...recentTransactionHistories.map((transactionHistory) {
                  return TransactionHistoryListItem(
                    onTap: () {},
                    transactionHistory: transactionHistory,
                  );
                }),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
