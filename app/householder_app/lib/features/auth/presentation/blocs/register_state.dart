part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final String email;

  const RegisterSuccess({required this.email});

  @override
  List<Object?> get props => [email];
}

class RegisterFailureState extends RegisterState {
  final String code;
  final Map<String, String> fieldErrors;

  const RegisterFailureState({required this.code, this.fieldErrors = const {}});

  @override
  List<Object?> get props => [code, fieldErrors];
}
