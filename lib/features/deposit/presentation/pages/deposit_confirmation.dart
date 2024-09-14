import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moniman/core/enums/routes.dart';
import 'package:moniman/core/extensions/router.dart';

class DepositConfirmationPage extends StatelessWidget {
  const DepositConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Confirmation'),
      ),
      body: Column(
        children: [
          const Text('Deposit Confirmation Page'),
          ElevatedButton(
            onPressed: () {
              context.go(AppRoute.dashboard.path);
            },
            child: const Text('Home'),
          )
        ],
      ),
    );
  }
}
