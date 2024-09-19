import 'package:flutter/material.dart';
import 'package:moniman/features/onboarding/presentation/widgets/onboarding_guard.dart';

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
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox(width: double.infinity),
          ),
        ),
      ),
    );
  }
}
