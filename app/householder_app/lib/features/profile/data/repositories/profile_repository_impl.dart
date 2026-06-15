import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/core.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_api.dart';
import '../models/update_user_dto.dart';
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

  @override
  Future<void> updateProfile(UpdateProfileParams params) async {
    try {
      await _api.updateUser(
        UpdateUserDto(
          firstName: params.firstName,
          lastName: params.lastName,
          phoneNumber: params.phoneNumber,
          nationality: params.nationality,
          gender: params.gender,
          birthdate: params.birthdate,
        ),
      );
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
  }) async {
    try {
      final form = FormData();
      form.files.add(
        MapEntry(
          'file',
          MultipartFile.fromBytes(bytes, filename: filename),
        ),
      );
      final dto = await _api.uploadAvatar(form);
      return dto.url;
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
