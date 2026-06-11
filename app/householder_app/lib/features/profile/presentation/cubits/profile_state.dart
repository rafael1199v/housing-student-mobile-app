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
  const ProfileLoaded(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileFailureState extends ProfileState {
  const ProfileFailureState(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
