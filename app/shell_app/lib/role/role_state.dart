part of 'role_cubit.dart';

class RoleState extends Equatable {
  const RoleState({
    this.heldRoles = const [],
    this.activeRole,
    this.loaded = false,
  });

  final List<AppRole> heldRoles;
  final AppRole? activeRole;
  final bool loaded;

  bool get canSwitch => heldRoles.length > 1;

  List<AppRole> get assignable => RoleHierarchy.assignableFor(heldRoles);

  @override
  List<Object?> get props => [heldRoles, activeRole, loaded];
}