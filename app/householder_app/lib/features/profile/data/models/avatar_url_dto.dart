import 'package:json_annotation/json_annotation.dart';

part 'avatar_url_dto.g.dart';

@JsonSerializable(createToJson: false)
class AvatarUrlDto {
  final String url;

  const AvatarUrlDto({required this.url});

  factory AvatarUrlDto.fromJson(Map<String, dynamic> json) =>
      _$AvatarUrlDtoFromJson(json);
}
