import 'package:json_annotation/json_annotation.dart';

part 'google_login_dto.g.dart';

@JsonSerializable(createFactory: false)
class GoogleLoginDto {
  const GoogleLoginDto({required this.idToken});

  final String idToken;

  Map<String, dynamic> toJson() => _$GoogleLoginDtoToJson(this);
}
