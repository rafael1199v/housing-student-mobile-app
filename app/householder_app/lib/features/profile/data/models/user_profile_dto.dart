import 'package:json_annotation/json_annotation.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class UserProfileDto {
  final String email;
  final String firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? nationality;
  final String? gender;
  final String? imageUrl;
  final String? birthdate;

  const UserProfileDto({
    required this.email,
    required this.firstName,
    this.lastName,
    this.phoneNumber,
    this.nationality,
    this.gender,
    this.imageUrl,
    this.birthdate,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);
}
