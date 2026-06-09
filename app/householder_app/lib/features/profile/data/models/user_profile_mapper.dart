import '../../domain/entities/user_profile.dart';
import 'user_profile_dto.dart';

extension UserProfileDtoMapper on UserProfileDto {
  UserProfile toUserProfile() => UserProfile(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        nationality: nationality,
        gender: gender,
        imageUrl: imageUrl,
        birthDate: birthdate,
      );
}
