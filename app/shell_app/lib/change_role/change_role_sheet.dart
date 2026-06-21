import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:housing_core/housing_core.dart';

import '../role/role_cubit.dart';
import 'role_labels.dart';

Future<void> showChangeRoleSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: GetIt.I<RoleCubit>(),
      child: const _ChangeRoleSheet(),
    ),
  );
}

class _ChangeRoleSheet extends StatefulWidget {
  const _ChangeRoleSheet();

  @override
  State<_ChangeRoleSheet> createState() => _ChangeRoleSheetState();
}

class _ChangeRoleSheetState extends State<_ChangeRoleSheet> {
  bool _busy = false;
  String? _error;

  Future<void> _acquire(AppRole role) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await GetIt.I<RoleService>().acquireRole(role);
      await GetIt.I<RoleCubit>().refreshFromToken();
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ahora también eres ${roleLabel(role)}.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = roleErrorMessage(ErrorMapper.map(e));
      });
    }
  }

  void _switchTo(AppRole role) {
    GetIt.I<RoleCubit>().setActive(role);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: BlocBuilder<RoleCubit, RoleState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Cambiar de rol', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),

                if (state.canSwitch) ...[
                  Text('Experiencia activa', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  for (final role in state.heldRoles)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        role == state.activeRole
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(roleLabel(role)),
                      enabled: !_busy && role != state.activeRole,
                      onTap: () => _switchTo(role),
                    ),
                  const SizedBox(height: 8),
                ],

                if (state.assignable.isNotEmpty) ...[
                  Text('Adquirir un rol', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  for (final role in state.assignable)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FilledButton.tonalIcon(
                        onPressed: _busy ? null : () => _acquire(role),
                        icon: const Icon(Icons.add),
                        label: Text('Convertirme en ${roleLabel(role)}'),
                      ),
                    ),
                ],

                if (_busy)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
