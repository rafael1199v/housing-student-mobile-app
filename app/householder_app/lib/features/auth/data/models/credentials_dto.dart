import 'package:json_annotation/json_annotation.dart';

part 'credentials_dto.g.dart';

@JsonSerializable(createToJson: false)
class CredentialsDto {
  final String accessToken;
  final String refreshToken;

  const CredentialsDto({required this.accessToken, required this.refreshToken});

  factory CredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$CredentialsDtoFromJson(json);
}
