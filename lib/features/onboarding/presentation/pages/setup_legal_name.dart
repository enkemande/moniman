import 'package:flutter/material.dart';
import 'package:moniman/features/onboarding/presentation/widgets/onboarding_guard.dart';
import 'package:moniman/features/user/presentation/widgets/update_legal_name_form.dart';

class SetupLegalNameOnboardingStepPage extends StatelessWidget {
  const SetupLegalNameOnboardingStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingGuard(
      isOnboardingScreen: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Setup Legal Name'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: UpdateLegalNameForm(
              actionLabel: 'Next',
            ),
          ),
        ),
      ),
    );
  }
}
