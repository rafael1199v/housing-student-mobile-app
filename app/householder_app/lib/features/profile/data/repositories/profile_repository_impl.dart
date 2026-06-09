import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_api.dart';
import '../models/user_profile_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi _api;

  const ProfileRepositoryImpl({required ProfileApi api}) : _api = api;

  @override
  Future<UserProfile> getProfile() async {
    try {
      final dto = await _api.getUser();
      return dto.toUserProfile();
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
