import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/deposit/domain/repositories/deposit.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  final DepositRepository depositRepository;
  final AuthBloc authBloc;

  DepositBloc({
    required this.depositRepository,
    required this.authBloc,
  }) : super(DepositInitial()) {
    on<DepositRequestEvent>(_handleDepositRequest);
  }

  void _handleDepositRequest(
    DepositRequestEvent event,
    Emitter<DepositState> emit,
  ) async {
    if (authBloc.state is Authenticated) {
      emit(DepositLoading());
      final authState = authBloc.state as Authenticated;
      final result = await depositRepository.deposit(
        amount: event.amount,
        userId: authState.user.uid,
        paymentMethodId: event.paymentMethodId,
      );
      result.fold(
        (failure) => emit(DepositError(failure.message)),
        (_) => emit(DepositSuccess()),
      );
    }
  }
}
