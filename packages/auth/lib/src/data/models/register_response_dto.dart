import 'package:json_annotation/json_annotation.dart';

part 'register_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class RegisterResponseDto {
  final String userId;

  const RegisterResponseDto({required this.userId});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);
}
