import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/account/presentation/widgets/account_balance_card.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/deposit/presentation/widgets/deposit_action_button.dart';
import 'package:moniman/features/transaction_history/presentation/widgets/recent_transaction_histories_card.dart';

class AccountDashboardPage extends StatelessWidget {
  const AccountDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const AccountBalanceCard(),
            const SizedBox(height: 10),
            const RecentTransactionHistoriesCard(),
            const DepositActionButton(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                  },
                  child: const Text('Logout'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
