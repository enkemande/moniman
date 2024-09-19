import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/onboarding/domain/entities/onboarding_step.dart';
import 'package:moniman/features/onboarding/domain/repositories/onboarding.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final AuthBloc authBloc;
  final OnboardingRepository onboardingRepository;
  late final StreamSubscription<AuthState> _authSubscription;
  late StreamSubscription<List<OnboardingStep>> _onboardingStepsSubscription;

  OnboardingBloc({
    required this.authBloc,
    required this.onboardingRepository,
  }) : super(OnboardingStepsInitial()) {
    on<CompleteOnboardingStepEvent>(_handleCompleteOnboardingStepEvent);
    on<SkipOnboardingStepEvent>(_handleSkipOnboardingStepEvent);
    on<OnboardingChangedEvent>(_handleOnboardingStepChangedEvent);
    _authSubscription = authBloc.stream.listen((authState) {
      if (authState is Authenticated) {
        _onboardingStepsSubscription = onboardingRepository
            .onStepsChange(authState.user.uid)
            .listen((steps) => add(OnboardingChangedEvent(steps)));
      }
    });
  }

  Future<void> _handleOnboardingStepChangedEvent(
    OnboardingChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingStepsLoading());
    if (event.steps.isNotEmpty) {
      emit(OnboardingStepsLoaded(event.steps));
    }
  }

  Future<void> _handleCompleteOnboardingStepEvent(
    CompleteOnboardingStepEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (authBloc.state is Authenticated) {
      final result = await onboardingRepository.completeStep(
        type: event.type,
        userId: (authBloc.state as Authenticated).user.uid,
      );
      result.fold(
        (failure) => emit(OnboardingStepsError(failure.message)),
        (_) => null,
      );
    }
  }

  Future<void> _handleSkipOnboardingStepEvent(
    SkipOnboardingStepEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (authBloc.state is Authenticated) {
      final result = await onboardingRepository.skipStep(
        type: event.type,
        userId: (authBloc.state as Authenticated).user.uid,
      );
      result.fold(
        (failure) => emit(OnboardingStepsError(failure.message)),
        (_) => null,
      );
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _onboardingStepsSubscription.cancel();
    return super.close();
  }
}
