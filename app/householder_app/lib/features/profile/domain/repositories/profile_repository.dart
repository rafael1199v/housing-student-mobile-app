import 'dart:typed_data';

import '../entities/update_profile_params.dart';
import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<void> updateProfile(UpdateProfileParams params);

  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
  });
}
