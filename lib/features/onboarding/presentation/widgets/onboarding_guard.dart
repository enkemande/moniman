import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moniman/core/enums/routes.dart';
import 'package:moniman/core/extensions/router.dart';
import 'package:moniman/features/onboarding/domain/bloc/onboarding_bloc.dart';

class OnboardingGuard extends StatelessWidget {
  final Widget child;
  final bool isOnboardingScreen;
  const OnboardingGuard({
    super.key,
    required this.child,
    this.isOnboardingScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        final router = GoRouter.of(context);
        if (state is OnboardingStepsLoaded) {
          if (!state.isCompleted) {
            router.go(state.currentStep.path);
          } else if (state.isCompleted && isOnboardingScreen) {
            router.go(AppRoute.dashboard.path);
          }
        }
      },
      builder: (context, state) {
        if (state is OnboardingStepsInitial ||
            state is OnboardingStepsLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is OnboardingStepsLoaded) {
          if (!state.isCompleted && !isOnboardingScreen) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return child;
        }

        return const SizedBox.shrink();
      },
    );
  }
}
