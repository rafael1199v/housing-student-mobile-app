import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(createFactory: false)
class LoginDto {
  final String email;
  final String password;

  const LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}
