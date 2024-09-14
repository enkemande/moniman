import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';

class VerifyOtpPage extends StatelessWidget {
  final String verificationId;
  final otpCodeController = TextEditingController();

  VerifyOtpPage({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter the OTP sent to your phone'),
                const SizedBox(height: 15),
                TextField(
                  controller: otpCodeController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    hintText: 'OTP Code',
                  ),
                ),
                Expanded(child: Container()),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          VerifyOtpEvent(
                            code: otpCodeController.text,
                            verificationId: verificationId,
                          ),
                        );
                  },
                  child: const Text('Verify OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
