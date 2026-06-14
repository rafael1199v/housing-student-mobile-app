import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../features/booking/booking.dart';
import '../../features/home/home.dart';
import '../../features/profile/profile.dart';
import '../../features/rooms/rooms.dart';
import '../session/session_notifier.dart';
import 'main_shell.dart';

const _publicRoutes = {
  LoginPage.routeName,
  RegisterPage.routeName,
  RegistrationEmailSentPage.routeName,
  ConfirmEmailPage.routeName,
};

final _shellNavigatorKey = GlobalKey<NavigatorState>();

String _extractToken(Uri uri) {
  for (final part in uri.query.split('&')) {
    final separator = part.indexOf('=');
    if (separator <= 0) continue;
    if (part.substring(0, separator) != 'token') continue;
    return Uri.decodeComponent(part.substring(separator + 1));
  }
  return '';
}

GoRouter createAppRouter(SessionNotifier session) {
  return GoRouter(
    initialLocation: HomePage.routeName,
    refreshListenable: session,
    redirect: (context, state) {
      if (state.matchedLocation == ConfirmEmailPage.routeName) return null;

      final loggedIn = session.isAuthenticated;
      final atPublic = _publicRoutes.contains(state.matchedLocation);

      if (!loggedIn) return atPublic ? null : LoginPage.routeName;
      if (atPublic) return HomePage.routeName;
      return null;
    },
    routes: [
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

      GoRoute(
        path: CreateRoomPage.routeName,
        builder: (context, state) => const CreateRoomPage(),
      ),

      GoRoute(
        path: RoomDetailPage.routeName,
        builder: (context, state) =>
            RoomDetailPage(roomId: int.parse(state.pathParameters['roomId']!)),
      ),

      GoRoute(
        path: BookingRequestsPage.routeName,
        builder: (context, state) => BookingRequestsPage(
          roomId: int.parse(state.pathParameters['roomId']!),
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: HomePage.routeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/messages',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProfilePage.routeName,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
