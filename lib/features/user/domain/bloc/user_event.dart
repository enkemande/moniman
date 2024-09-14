part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserChangedEvent extends UserEvent {
  final User? user;

  const UserChangedEvent(this.user);

  @override
  List<Object> get props => [];
}

class UpdateUserEvent extends UserEvent {
  final User user;

  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
