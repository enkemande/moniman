import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moniman/core/enums/routes.dart';
import 'package:moniman/core/extensions/router.dart';
import 'package:moniman/core/presentation/theme/app_color.dart';
import 'package:moniman/features/deposit/domain/bloc/deposit_bloc.dart';

class DepositPage extends StatelessWidget {
  final amountController = TextEditingController();

  DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepositBloc, DepositState>(
      listener: (context, state) {
        if (state is DepositSuccess) {
          context.push(AppRoute.depositConfirmation.path);
        }

        if (state is DepositError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deposit'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              const SizedBox(height: 15),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  final amount = int.parse(amountController.text);
                  context.read<DepositBloc>().add(DepositRequestEvent(
                        amount: amount,
                        paymentMethodId: '',
                      ));
                },
                child: const Text('Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
