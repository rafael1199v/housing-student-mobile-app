import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/usecases/update_profile_usecase.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({required UpdateProfileUseCase updateProfileUseCase})
      : _updateProfileUseCase = updateProfileUseCase,
        super(const EditProfileInitial());

  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> submit(UpdateProfileParams params) async {
    emit(const EditProfileSubmitting());
    try {
      await _updateProfileUseCase(params);
      emit(const EditProfileSuccess());
    } on Failure catch (failure) {
      emit(
        EditProfileFailure(
          code: failure.code,
          fieldErrors:
              failure is ValidationFailure ? failure.fieldErrors : const {},
        ),
      );
    } catch (_) {
      emit(const EditProfileFailure(code: 'unknown.error'));
    }
  }
}
