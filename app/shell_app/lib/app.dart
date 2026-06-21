import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:householder_app/core/core.dart'
    show AppLocalizations, LocaleCubit, SessionNotifier, ThemeCubit, getIt;
import 'package:housing_core/housing_core.dart';
import 'package:housing_design_system/housing_design_system.dart';
import 'package:student_lib/student_experience.dart' as student;

import 'change_role/change_role_fab.dart';
import 'role/role_cubit.dart';
import 'router/shell_router.dart';

class ShellApp extends StatefulWidget {
  const ShellApp({super.key});

  @override
  State<ShellApp> createState() => _ShellAppState();
}

class _ShellAppState extends State<ShellApp> {
  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellRoot');

  late final SessionNotifier _session = getIt<SessionNotifier>();
  late final RoleCubit _roleCubit = getIt<RoleCubit>();

  @override
  void initState() {
    super.initState();
    _session.addListener(_onSessionChanged);
    if (_session.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _roleCubit.refreshFromToken();
      });
    }
  }

  void _onSessionChanged() {
    if (_session.isAuthenticated) {
      _roleCubit.refreshFromToken();
    } else {
      _roleCubit.reset();
    }
  }

  @override
  void dispose() {
    _session.removeListener(_onSessionChanged);
    super.dispose();
  }

  bool _isStudent(AppRole? active) => active == AppRole.student;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        student.dioProvider.overrideWithValue(getIt<Dio>()),
        student.localeHookProvider
            .overrideWithValue((locale) => getIt<LocaleCubit>().setLocale(locale)),
        student.logoutHookProvider
            .overrideWithValue(() => getIt<SessionNotifier>().signedOut()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
          BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
          BlocProvider<RoleCubit>.value(value: _roleCubit),
        ],
        child: BlocBuilder<RoleCubit, RoleState>(
          buildWhen: (prev, curr) => prev.activeRole != curr.activeRole,
          builder: (context, roleState) {
            final router = buildShellRouter(
              navigatorKey: _rootNavigatorKey,
              session: _session,
              activeRole: roleState.activeRole,
            );
            final isStudent = _isStudent(roleState.activeRole);

            return BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return BlocBuilder<LocaleCubit, Locale>(
                  builder: (context, locale) {
                    return MaterialApp.router(
                      title: 'Itersapiens',
                      debugShowCheckedModeBanner: false,
                      theme: isStudent ? AppTheme.student : AppTheme.householder,
                      darkTheme: isStudent
                          ? AppTheme.studentDark
                          : AppTheme.householderDark,
                      themeMode: themeMode,
                      locale: locale,
                      localizationsDelegates: [
                        ...AppLocalizations.localizationsDelegates,
                        student.AppLocalizations.delegate,
                      ],
                      supportedLocales: AppLocalizations.supportedLocales,
                      routerConfig: router,
                      builder: (context, child) => Stack(
                        children: [
                          ?child,
                          ChangeRoleFab(
                            rootNavigatorContext: () =>
                                _rootNavigatorKey.currentContext,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}