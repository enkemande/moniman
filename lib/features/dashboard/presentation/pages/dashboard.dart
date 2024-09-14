import 'package:flutter/material.dart';
import 'package:moniman/features/dashboard/presentation/widgets/app_services.dart';
import 'package:moniman/features/user/presentation/widgets/account_balance_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Money'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: const SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountBalanceCard(),
                SizedBox(height: 10),
                AppServices(),
                SizedBox(height: 10),
                // RecentTransactionsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
