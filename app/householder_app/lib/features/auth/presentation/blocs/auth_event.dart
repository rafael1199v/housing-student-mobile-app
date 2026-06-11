part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  
  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GoogleAuthSubmitted extends AuthEvent {
  const GoogleAuthSubmitted(this.idToken);

  final String idToken;

  @override
  List<Object?> get props => [idToken];
}
