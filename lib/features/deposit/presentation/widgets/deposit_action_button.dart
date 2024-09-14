import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moniman/core/enums/routes.dart';
import 'package:moniman/core/extensions/router.dart';

class DepositActionButton extends StatelessWidget {
  const DepositActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.push(AppRoute.deposit.path);
      },
      child: const Text('Deposit'),
    );
  }
}
