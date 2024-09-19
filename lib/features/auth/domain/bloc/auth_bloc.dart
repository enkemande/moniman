import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:moniman/features/auth/domain/entities/user.dart';
import 'package:moniman/features/auth/domain/repositories/auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User> _authSubscription;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthStateChangeEvent>(_handleAuthStateChange);
    on<VerifyPhoneNumberEvent>(_handleVerifyPhoneNumber);
    on<VerifyOtpEvent>(_handleVerifyOtp);
    on<SignOutEvent>(_handleSignOut);
    _authSubscription = authRepository.onAuthStateChanged().listen((user) {
      add(AuthStateChangeEvent(user));
    });
  }

  void _handleAuthStateChange(
    AuthStateChangeEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user.isEmpty) {
      emit(Unauthenticated());
    } else {
      emit(Authenticated(event.user));
    }
    if (!kIsWeb) {
      await Future.delayed(const Duration(seconds: 1));
      FlutterNativeSplash.remove();
    }
  }

  void _handleVerifyPhoneNumber(
    VerifyPhoneNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.verifyPhoneNumber(
      phoneNumber: event.phoneNumber,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (result) {
        if (result is String) {
          emit(AuthOtpSent(result));
        } else if (result is User) {
          emit(Authenticated(result));
        }
      },
    );
  }

  void _handleVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.verifyOtp(
      code: event.code,
      verificationId: event.verificationId,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => null,
    );
  }

  void _handleSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
