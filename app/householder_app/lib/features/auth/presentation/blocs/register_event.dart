part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String nationality;
  final String gender;
  final String birthDate;

  const RegisterSubmitted({
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.nationality,
    required this.gender,
    required this.birthDate,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    role,
    firstName,
    lastName,
    phoneNumber,
    nationality,
    gender,
    birthDate,
  ];
}
