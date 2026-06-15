import 'package:json_annotation/json_annotation.dart';

part 'update_user_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class UpdateUserDto {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? nationality;
  final String? gender;
  final String? birthdate;

  const UpdateUserDto({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.nationality,
    this.gender,
    this.birthdate,
  });

  Map<String, dynamic> toJson() => _$UpdateUserDtoToJson(this);
}
