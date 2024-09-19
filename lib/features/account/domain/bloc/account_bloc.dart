import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/account/domain/entities/account.dart';
import 'package:moniman/features/account/domain/enums/account_status.dart';
import 'package:moniman/features/account/domain/repositories/account.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthBloc authBloc;
  final AccountRepository accountRepository;
  late final StreamSubscription<AuthState> _authBlocSubscription;
  late StreamSubscription<Account> _accountBlocSubscription;

  AccountBloc({
    required this.authBloc,
    required this.accountRepository,
  }) : super(AccountInitial()) {
    on<AccountStateChangeEvent>(_handleAccountStateChangeEvent);
    _authBlocSubscription = authBloc.stream.listen((state) {
      if (state is Authenticated) {
        _accountBlocSubscription = accountRepository
            .onAccountStateChange(state.user.uid)
            .listen((event) => add(AccountStateChangeEvent(event)));
      }
    });
  }

  void _handleAccountStateChangeEvent(
    AccountStateChangeEvent event,
    Emitter<AccountState> emit,
  ) {
    if (event.account.status == AccountStatus.suspended) {
      emit(AccountSuspended());
    } else {
      emit(AccountLoaded(event.account));
    }
  }

  @override
  Future<void> close() {
    _authBlocSubscription.cancel();
    _accountBlocSubscription.cancel();
    return super.close();
  }
}
