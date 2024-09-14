import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/onboarding/domain/bloc/onboarding_bloc.dart';
import 'package:moniman/features/user/domain/entities/user.dart';
import 'package:moniman/features/user/domain/repositories/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final OnboardingBloc onboardingBloc;
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _authSubscription;
  late StreamSubscription<User?> _userSubscription;

  UserBloc({
    required this.userRepository,
    required this.authBloc,
    required this.onboardingBloc,
  }) : super(UserInitial()) {
    on<UserChangedEvent>(_handleUserChangedEvent);
    on<UpdateUserEvent>(_handleUpdateUserEvent);
    _authSubscription = authBloc.stream.listen((authState) {
      if (authState is Authenticated) {
        final userId = authState.session.uid;
        _userSubscription = userRepository
            .onUserChange(userId: userId!)
            .listen((user) => add(UserChangedEvent(user)));
      }
    });
  }

  Future<void> _handleUserChangedEvent(
    UserChangedEvent event,
    Emitter<UserState> emit,
  ) async {
    if (event.user == null) {
      emit(UserInitial());
    } else {
      emit(UserLoaded(event.user!));
    }
  }

  Future<void> _handleUpdateUserEvent(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserUpdating());
    try {
      await userRepository.updateUser(event.user);
      emit(UserLoaded(event.user));
      if (onboardingBloc.state is OnboardingStepsLoaded) {
        final state = onboardingBloc.state as OnboardingStepsLoaded;
        onboardingBloc.add(CompleteOnboardingStepEvent(state.currentStep.type));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _userSubscription.cancel();
    return super.close();
  }
}
