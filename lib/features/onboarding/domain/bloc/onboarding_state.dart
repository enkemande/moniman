part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingStepsInitial extends OnboardingState {}

final class OnboardingStepsLoading extends OnboardingState {}

final class OnboardingStepsLoaded extends OnboardingState {
  final List<OnboardingStep> steps;

  const OnboardingStepsLoaded(this.steps);

  OnboardingStep get currentStep {
    return steps.firstWhere(
      (element) => !element.completed,
      orElse: () => OnboardingStep.empty(),
    );
  }

  bool get isCompleted {
    return steps.every((element) => element.completed);
  }

  @override
  List<Object> get props => [steps, currentStep, isCompleted];
}

final class OnboardingStepsError extends OnboardingState {
  final String message;

  const OnboardingStepsError(this.message);

  @override
  List<Object> get props => [message];
}
