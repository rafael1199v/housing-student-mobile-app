import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:housing_core/housing_core.dart';

import '../change_role/change_role_sheet.dart';
import 'role_cubit.dart';


class RoleSwitchControllerImpl extends RoleSwitchController {
  RoleSwitchControllerImpl({
    required RoleCubit roleCubit,
    required this.rootNavigatorContext,
  }) {
    _canChangeRole = _availabilityOf(roleCubit.state);
    _subscription = roleCubit.stream.listen(_onStateChanged);
  }

  final BuildContext? Function() rootNavigatorContext;

  late bool _canChangeRole;
  late final StreamSubscription<RoleState> _subscription;

  static bool _availabilityOf(RoleState state) =>
      state.activeRole != null &&
      (state.canSwitch || state.assignable.isNotEmpty);

  void _onStateChanged(RoleState state) {
    final next = _availabilityOf(state);
    if (next == _canChangeRole) return;
    _canChangeRole = next;
    notifyListeners();
  }

  @override
  bool get canChangeRole => _canChangeRole;

  @override
  void open(BuildContext context) {
    final ctx = rootNavigatorContext() ?? context;
    showChangeRoleSheet(ctx);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
