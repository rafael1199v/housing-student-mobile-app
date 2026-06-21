import 'package:json_annotation/json_annotation.dart';

part 'google_register_dto.g.dart';

@JsonSerializable(createFactory: false)
class GoogleRegisterDto {
  const GoogleRegisterDto({required this.idToken, required this.role});

  final String idToken;
  final String role;

  Map<String, dynamic> toJson() => _$GoogleRegisterDtoToJson(this);
}
