import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class RegisterDto {
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String nationality;
  final String gender;
  final String birthDate;

  const RegisterDto({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.nationality,
    required this.gender,
    required this.birthDate,
    this.role = 'Householder',
  });

  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);
}
