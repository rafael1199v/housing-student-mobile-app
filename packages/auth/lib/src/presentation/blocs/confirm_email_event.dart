part of 'confirm_email_bloc.dart';

sealed class ConfirmEmailEvent extends Equatable {
  const ConfirmEmailEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmEmailRequested extends ConfirmEmailEvent {
  final String userId;
  final String token;

  const ConfirmEmailRequested({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}
