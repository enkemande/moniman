part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AccountStateChangeEvent extends AccountEvent {
  final Account account;

  const AccountStateChangeEvent(this.account);

  @override
  List<Object> get props => [account];
}
