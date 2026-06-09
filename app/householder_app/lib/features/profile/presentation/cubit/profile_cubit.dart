import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required TokenStorage tokenStorage,
    required SessionNotifier sessionNotifier,
  })  : _getProfileUseCase = getProfileUseCase,
        _tokenStorage = tokenStorage,
        _sessionNotifier = sessionNotifier,
        super(const ProfileLoading());

  final GetProfileUseCase _getProfileUseCase;
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

  Future<void> signOut() async {
    await _tokenStorage.clear();
    _sessionNotifier.signedOut();
  }
}
