import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String? uid;

  const Session({
    required this.uid,
  });

  @override
  List<Object?> get props => [uid];
}
