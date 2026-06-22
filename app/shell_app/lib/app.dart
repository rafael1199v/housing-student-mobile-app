import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:householder_app/core/core.dart'
    show AppLocalizations, LocaleCubit, ThemeCubit, getIt;
import 'package:housing_auth/housing_auth.dart' show AuthLocalizations;
import 'package:housing_core/housing_core.dart';
import 'package:housing_design_system/housing_design_system.dart';
import 'package:student_lib/student_experience.dart' as student;

import 'bootstrap.dart' show rootNavigatorKey;
import 'observability/crash_keys.dart';
import 'role/role_cubit.dart';
import 'router/pending_deep_link.dart';
import 'router/shell_router.dart';

class ShellApp extends StatefulWidget {
  const ShellApp({super.key});

  @override
  State<ShellApp> createState() => _ShellAppState();
}

class _ShellAppState extends State<ShellApp> {
  late final SessionNotifier _session = getIt<SessionNotifier>();
  late final RoleCubit _roleCubit = getIt<RoleCubit>();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;
  Uri? _handledInitial;
  bool _initialEchoSkipped = false;

  @override
  void initState() {
    super.initState();
    _session.addListener(_onSessionChanged);
    if (_session.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _roleCubit.refreshFromToken();
      });
      _syncCrashUser();
    }
    if (!kIsWeb) {
      _initDeepLinks();
    }
  }

  Future<void> _initDeepLinks() async {
    _handledInitial = await _appLinks.getInitialLink();
    if (_handledInitial != null) {
      _routeDeepLink(_handledInitial!);
    }
    _linkSub = _appLinks.uriLinkStream.listen((uri) {
      if (!_initialEchoSkipped && uri == _handledInitial) {
        _initialEchoSkipped = true;
        return;
      }
      _initialEchoSkipped = true;
      _routeDeepLink(uri);
    });
  }

  void _routeDeepLink(Uri uri) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }
    final location =
        uri.query.isEmpty ? uri.path : '${uri.path}?${uri.query}';
    final router = GoRouter.of(context);

    if (uri.path.startsWith('/room/')) {
      router.push(location);
    } else {
      router.go(location);
    }
  }

  void _onSessionChanged() {
    if (_session.isAuthenticated) {
      _roleCubit.refreshFromToken();
      _syncCrashUser();
    } else {
      _roleCubit.reset();
      getIt<PendingDeepLink>().clear();
      CrashKeys.setUser(null);
    }
  }

  Future<void> _syncCrashUser() async {
    final userId = await getIt<CurrentUserService>().currentUserId();
    await CrashKeys.setUser(userId);
  }

  @override
  void dispose() {
    _linkSub?.cancel();
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
        student.changeRoleHookProvider.overrideWithValue(
          (context) => getIt<RoleSwitchController>().open(context),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
          BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
          BlocProvider<RoleCubit>.value(value: _roleCubit),
        ],
        child: BlocConsumer<RoleCubit, RoleState>(
          listenWhen: (prev, curr) => prev.activeRole != curr.activeRole,
          listener: (context, roleState) {
            CrashKeys.setActiveRole(
              roleState.activeRole?.name ?? 'none',
              isStudent: _isStudent(roleState.activeRole),
            );
          },
          buildWhen: (prev, curr) => prev.activeRole != curr.activeRole,
          builder: (context, roleState) {
            final router = buildShellRouter(
              navigatorKey: rootNavigatorKey,
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
                        AuthLocalizations.delegate,
                        student.AppLocalizations.delegate,
                      ],
                      supportedLocales: AppLocalizations.supportedLocales,
                      routerConfig: router,
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