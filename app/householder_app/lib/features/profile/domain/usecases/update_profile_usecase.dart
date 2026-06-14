import '../entities/update_profile_params.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<void> call(UpdateProfileParams params) =>
      _repository.updateProfile(params);
}
