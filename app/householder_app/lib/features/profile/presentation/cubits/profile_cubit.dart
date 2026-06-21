import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required UploadAvatarUseCase uploadAvatarUseCase,
    required TokenStorage tokenStorage,
    required SessionNotifier sessionNotifier,
  })  : _getProfileUseCase = getProfileUseCase,
        _uploadAvatarUseCase = uploadAvatarUseCase,
        _tokenStorage = tokenStorage,
        _sessionNotifier = sessionNotifier,
        super(const ProfileLoading());

  final GetProfileUseCase _getProfileUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final TokenStorage _tokenStorage;
  final SessionNotifier _sessionNotifier;

  Future<void> load() async {
    emit(const ProfileLoading());
    try {
      final profile = await _getProfileUseCase();
      emit(ProfileLoaded(profile));
    } on Failure catch (failure) {
      emit(ProfileFailureState(failure.code));
    } catch (_) {
      emit(const ProfileFailureState('unknown.error'));
    }
  }

  Future<void> uploadAvatar(Uint8List bytes, String filename) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    emit(ProfileLoaded(current.profile, avatarUploading: true));
    try {
      await _uploadAvatarUseCase(bytes: bytes, filename: filename);
      await load();
    } on Failure catch (failure) {
      emit(ProfileAvatarError(current.profile, failure.code));
      emit(ProfileLoaded(current.profile));
    } catch (_) {
      emit(ProfileAvatarError(current.profile, 'unknown.error'));
      emit(ProfileLoaded(current.profile));
    }
  }

  Future<void> signOut() async {
    await _tokenStorage.clear();
    _sessionNotifier.signedOut();
  }
}
