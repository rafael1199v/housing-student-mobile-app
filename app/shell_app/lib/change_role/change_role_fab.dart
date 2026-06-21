import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../role/role_cubit.dart';
import '../role/role_state.dart';
import 'change_role_sheet.dart';

class ChangeRoleFab extends StatelessWidget {
  const ChangeRoleFab({super.key, required this.rootNavigatorContext});

  final BuildContext? Function() rootNavigatorContext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, RoleState>(
      builder: (context, state) {
        final visible = state.activeRole != null &&
            (state.canSwitch || state.assignable.isNotEmpty);
        if (!visible) return const SizedBox.shrink();
        return Positioned(
          right: 16,
          bottom: 96,
          child: Semantics(
            button: true,
            label: 'Cambiar de rol',
            child: FloatingActionButton.small(
              heroTag: 'change-role-fab',
              onPressed: () {
                final ctx = rootNavigatorContext() ?? context;
                showChangeRoleSheet(ctx);
              },
              child: const Icon(Icons.swap_horiz),
            ),
          ),
        );
      },
    );
  }
}
