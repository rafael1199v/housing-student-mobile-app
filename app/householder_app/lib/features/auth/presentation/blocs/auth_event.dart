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

class GoogleRoleSelected extends AuthEvent {
  const GoogleRoleSelected({required this.idToken, required this.role});

  final String idToken;
  final String role;

  @override
  List<Object?> get props => [idToken, role];
}
