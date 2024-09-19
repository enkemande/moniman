import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/transaction_history/domain/entities/transaction_history.dart';
import 'package:moniman/features/transaction_history/domain/repositories/transaction_history.dart';

part 'transaction_history_event.dart';
part 'transaction_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final TransactionHistoryRepository transactionHistoryRepository;
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _authBlocSubscription;
  late StreamSubscription<List<TransactionHistory>>
      _transactionHistoriesSubscription;

  TransactionHistoryBloc({
    required this.transactionHistoryRepository,
    required this.authBloc,
  }) : super(TransactionHistoryInitial()) {
    on<TransactionHistoriesChanged>(_handleTransactionHistoriesChanged);
    _authBlocSubscription = authBloc.stream.listen((authState) {
      if (authState is Authenticated) {
        _transactionHistoriesSubscription = transactionHistoryRepository
            .listenToTransactionHistoryChanges(authState.user.uid)
            .listen((transactionHistories) {
          add(TransactionHistoriesChanged(transactionHistories));
        });
      }
    });
  }

  void _handleTransactionHistoriesChanged(
    TransactionHistoriesChanged event,
    Emitter<TransactionHistoryState> emit,
  ) {
    print('TransactionHistoriesChanged: ${event.transactionHistories}');
    emit(TransactionHistoriesLoaded(event.transactionHistories));
  }

  @override
  Future<void> close() {
    _authBlocSubscription.cancel();
    _transactionHistoriesSubscription.cancel();
    return super.close();
  }
}
