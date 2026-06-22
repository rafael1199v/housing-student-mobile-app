import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_core/housing_core.dart';

part 'role_state.dart';

class RoleCubit extends Cubit<RoleState> {
  RoleCubit({required CurrentUserService currentUser})
      : _currentUser = currentUser,
        super(const RoleState());

  final CurrentUserService _currentUser;

  Future<void> refreshFromToken() async {
    final raw = await _currentUser.currentRoles();
    final held = AppRole.fromWireList(raw);
    final keepCurrent =
        state.activeRole != null && held.contains(state.activeRole);
    final next = RoleState(
      heldRoles: held,
      activeRole: keepCurrent ? state.activeRole : RoleHierarchy.defaultActive(held),
      loaded: true,
    );
    emit(next);
  }

  void setActive(AppRole role) {
    if (role == state.activeRole || !state.heldRoles.contains(role)) return;
    emit(RoleState(heldRoles: state.heldRoles, activeRole: role, loaded: true));
  }

  void reset() => emit(const RoleState());
}
