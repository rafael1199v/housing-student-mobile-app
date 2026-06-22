import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:householder_app/core/core.dart' show getIt;
import 'package:householder_app/householder_experience.dart';
import 'package:housing_auth/housing_auth.dart';
import 'package:housing_core/housing_core.dart';
import 'package:student_lib/student_experience.dart' as student;

import 'pending_deep_link.dart';
import 'room_deep_link_gate.dart';

const _publicRoutes = {
  LoginPage.routeName,
  RegisterPage.routeName,
  RegistrationEmailSentPage.routeName,
  ConfirmEmailPage.routeName,
};

String _extractToken(Uri uri) {
  for (final part in uri.query.split('&')) {
    final separator = part.indexOf('=');
    if (separator <= 0) continue;
    if (part.substring(0, separator) != 'token') continue;
    return Uri.decodeComponent(part.substring(separator + 1));
  }
  return '';
}

List<RouteBase> _authRoutes() => [
  GoRoute(
    path: LoginPage.routeName,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: RegisterPage.routeName,
    builder: (context, state) => const RegisterPage(),
  ),
  GoRoute(
    path: RegistrationEmailSentPage.routeName,
    builder: (context, state) => RegistrationEmailSentPage(
      email: state.extra is String ? state.extra as String : '',
    ),
  ),
  GoRoute(
    path: ConfirmEmailPage.routeName,
    builder: (context, state) => ConfirmEmailPage(
      userId: state.uri.queryParameters['userId'] ?? '',
      token: _extractToken(state.uri),
    ),
  ),
];

String homeLocationFor(AppRole? activeRole) => switch (activeRole) {
  AppRole.householder => householderInitialLocation,
  AppRole.student => student.studentInitialLocation,
  _ => LoginPage.routeName,
};

List<RouteBase> _experienceRoutesFor(AppRole? activeRole) => switch (activeRole) {
  AppRole.householder => householderExperienceRoutes(),
  AppRole.student => student.studentExperienceRoutes(),
  _ => const <RouteBase>[],
};

GoRouter buildShellRouter({
  required GlobalKey<NavigatorState> navigatorKey,
  required SessionNotifier session,
  required AppRole? activeRole,
}) {
  final home = homeLocationFor(activeRole);
  final pending = getIt<PendingDeepLink>();

  var initialLocation = home;
  if (activeRole == AppRole.student) {
    final target = pending.consume();
    if (target != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentContext?.push(target);
      });
    }
  } else {
    final target = pending.peek();
    if (target != null) initialLocation = target;
  }

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    refreshListenable: session,
    redirect: (context, state) {
      if (state.matchedLocation == ConfirmEmailPage.routeName) return null;

      if (activeRole != AppRole.student &&
          state.matchedLocation.startsWith('/room/')) {
        pending.set(state.uri.toString());
      }

      final loggedIn = session.isAuthenticated;
      final atPublic = _publicRoutes.contains(state.matchedLocation);

      if (!loggedIn) return atPublic ? null : LoginPage.routeName;
      if (atPublic) return home;
      return null;
    },
    routes: [
      ..._authRoutes(),
      if (activeRole != AppRole.student)
        GoRoute(
          path: '/room/:id',
          builder: (context, state) =>
              RoomDeepLinkGate(roomId: state.pathParameters['id'] ?? ''),
        ),
      ..._experienceRoutesFor(activeRole),
    ],
  );
}
