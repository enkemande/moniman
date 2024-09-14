import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moniman/core/enums/routes.dart';
import 'package:moniman/core/extensions/router.dart';
import 'package:moniman/core/presentation/theme/app_color.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';

class VerifyPhoneNumberPage extends StatelessWidget {
  final phoneNumberController = TextEditingController(text: '+17137051803');
  VerifyPhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          context.push(
            '${AppRoute.verifyOtp.path}?verificationId=${state.verificationId}',
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your phone number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'We will send you a verification code to this number',
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: phoneNumberController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                  ),
                ),
                Expanded(child: Container()),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                        VerifyPhoneNumberEvent(phoneNumberController.text));
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
