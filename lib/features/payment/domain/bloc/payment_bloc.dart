import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/payment/domain/repositories/payment.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({
    required this.paymentRepository,
  }) : super(PaymentInitial()) {
    on<SendMoneyPaymentEvent>(_handleSendMoneyPayment);
    on<RequestPaymentEvent>(_handleRequestPayment);
  }

  void _handleSendMoneyPayment(
    SendMoneyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await paymentRepository.pay(
      amount: event.amount,
      accountId: event.accountId,
      paymentMethodId: event.paymentMethodId,
    );
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (_) => emit(PaymentSuccess()),
    );
  }

  void _handleRequestPayment(
    RequestPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await paymentRepository.request(
      amount: event.amount,
      accountId: event.accountId,
    );
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (_) => emit(PaymentSuccess()),
    );
  }
}
