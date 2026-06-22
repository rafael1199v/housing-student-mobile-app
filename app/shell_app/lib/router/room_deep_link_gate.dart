import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:householder_app/core/core.dart' show AppLocalizations, getIt;
import 'package:housing_core/housing_core.dart';

import '../role/role_cubit.dart';
import 'pending_deep_link.dart';
import 'shell_router.dart' show homeLocationFor;

class RoomDeepLinkGate extends StatefulWidget {
  const RoomDeepLinkGate({super.key, required this.roomId});

  final String roomId;

  @override
  State<RoomDeepLinkGate> createState() => _RoomDeepLinkGateState();
}

class _RoomDeepLinkGateState extends State<RoomDeepLinkGate> {
  bool _handled = false;

  String get _target => '/room/${widget.roomId}';

  void _maybeAct(RoleState state) {
    if (_handled || !state.loaded) return;
    _handled = true;

    if (state.heldRoles.contains(AppRole.student)) {
      getIt<PendingDeepLink>().set(_target);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<RoleCubit>().setActive(AppRole.student);
      });
    } else {
      getIt<PendingDeepLink>().clear();
      final messenger = ScaffoldMessenger.of(context);
      final message = AppLocalizations.of(context).deepLinkRoleUnavailable;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go(homeLocationFor(state.activeRole));
        messenger.showSnackBar(SnackBar(content: Text(message)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoleCubit, RoleState>(
      listenWhen: (prev, curr) =>
          prev.loaded != curr.loaded || prev.heldRoles != curr.heldRoles,
      listener: (context, state) => _maybeAct(state),
      builder: (context, state) {
        _maybeAct(state);
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
