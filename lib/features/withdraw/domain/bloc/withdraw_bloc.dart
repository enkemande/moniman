import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/withdraw/domain/repositories/withdraw.dart';

part 'withdraw_event.dart';
part 'withdraw_state.dart';

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  final WithdrawRepository withdrawRepository;

  WithdrawBloc({
    required this.withdrawRepository,
  }) : super(WithdrawInitial()) {
    on<WithdrawRequestEvent>(_handleWithdrawRequest);
  }

  void _handleWithdrawRequest(
    WithdrawRequestEvent event,
    Emitter<WithdrawState> emit,
  ) async {
    emit(WithdrawLoading());
    final result = await withdrawRepository.withdraw(
      amount: event.amount,
      userId: event.accountId,
      paymentMethodId: event.paymentMethodId,
    );
    result.fold(
      (failure) => emit(WithdrawError(failure.message)),
      (_) => emit(WithdrawSuccess()),
    );
  }
}
