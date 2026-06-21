part of 'confirm_email_bloc.dart';

sealed class ConfirmEmailState extends Equatable {
  const ConfirmEmailState();

  @override
  List<Object?> get props => [];
}

class ConfirmEmailInitial extends ConfirmEmailState {
  const ConfirmEmailInitial();
}

class ConfirmEmailLoading extends ConfirmEmailState {
  const ConfirmEmailLoading();
}

class ConfirmEmailSuccess extends ConfirmEmailState {
  const ConfirmEmailSuccess();
}

class ConfirmEmailFailureState extends ConfirmEmailState {
  final String code;

  const ConfirmEmailFailureState({required this.code});

  @override
  List<Object?> get props => [code];
}
