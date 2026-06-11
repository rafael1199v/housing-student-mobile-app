part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

class AuthFailureState extends AuthState {
  final String code;
  final Map<String, String> fieldErrors;
  
  const AuthFailureState({required this.code, this.fieldErrors = const {}});

  @override
  List<Object?> get props => [code, fieldErrors];
}
