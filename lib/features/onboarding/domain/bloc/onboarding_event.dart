part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingChangedEvent extends OnboardingEvent {
  final List<OnboardingStep> steps;

  const OnboardingChangedEvent(this.steps);

  @override
  List<Object> get props => [steps];
}

class CompleteOnboardingStepEvent extends OnboardingEvent {
  final String type;

  const CompleteOnboardingStepEvent(this.type);

  @override
  List<Object> get props => [type];
}

class SkipOnboardingStepEvent extends OnboardingEvent {
  final String type;

  const SkipOnboardingStepEvent(this.type);

  @override
  List<Object> get props => [type];
}
