import 'dart:typed_data';

import '../repositories/profile_repository.dart';

class UploadAvatarUseCase {
  final ProfileRepository _repository;

  const UploadAvatarUseCase(this._repository);

  Future<String> call({
    required Uint8List bytes,
    required String filename,
  }) =>
      _repository.uploadAvatar(bytes: bytes, filename: filename);
}
