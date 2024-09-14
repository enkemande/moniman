import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/transactions/domain/entities/transaction.dart';
import 'package:moniman/features/transactions/domain/repositories/transaction.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionRepository transactionRepository;
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _authSubscription;
  late StreamSubscription<List<Transaction>> _transactionsSubscription;

  TransactionsBloc({
    required this.transactionRepository,
    required this.authBloc,
  }) : super(TransactionsInitial()) {
    on<TransactionsChangedEvent>(_handleTransactionsChanged);
    _authSubscription = authBloc.stream.listen((authState) {
      if (authState is Authenticated) {
        final userId = authState.session.uid;
        _transactionsSubscription =
            transactionRepository.onTransactionsChange(userId: userId!).listen(
          (transactions) {
            add(TransactionsChangedEvent(transactions));
          },
        );
      }
    });
  }

  void _handleTransactionsChanged(
    TransactionsChangedEvent event,
    Emitter<TransactionsState> emit,
  ) {
    print(event.transactions);
    emit(TransactionsLoaded(event.transactions));
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _transactionsSubscription.cancel();
    return super.close();
  }
}
