part of 'edit_profile_cubit.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileSubmitting extends EditProfileState {
  const EditProfileSubmitting();
}

class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess();
}

class EditProfileFailure extends EditProfileState {
  const EditProfileFailure({
    required this.code,
    this.fieldErrors = const {},
  });

  final String code;
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [code, fieldErrors];
}
