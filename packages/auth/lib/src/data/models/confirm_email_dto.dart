import 'package:json_annotation/json_annotation.dart';

part 'confirm_email_dto.g.dart';

@JsonSerializable(createFactory: false)
class ConfirmEmailDto {
  final String userId;
  final String token;

  const ConfirmEmailDto({required this.userId, required this.token});

  Map<String, dynamic> toJson() => _$ConfirmEmailDtoToJson(this);
}
