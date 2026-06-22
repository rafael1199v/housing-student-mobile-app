import 'package:json_annotation/json_annotation.dart';

import 'credentials_dto.dart';

part 'google_auth_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class GoogleAuthResponseDto {
  const GoogleAuthResponseDto({required this.isNewUser, this.credentials});

  factory GoogleAuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthResponseDtoFromJson(json);

  final bool isNewUser;
  final CredentialsDto? credentials;
}
