part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile, {this.avatarUploading = false});

  final UserProfile profile;
  final bool avatarUploading;

  @override
  List<Object?> get props => [profile, avatarUploading];
}

class ProfileAvatarError extends ProfileState {
  ProfileAvatarError(this.profile, this.code)
      : errorId = DateTime.now().microsecondsSinceEpoch;

  final UserProfile profile;
  final String code;
  final int errorId;

  @override
  List<Object?> get props => [profile, code, errorId];
}

class ProfileFailureState extends ProfileState {
  const ProfileFailureState(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
