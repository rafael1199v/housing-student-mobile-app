import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../features/home/home.dart';
import '../../features/profile/profile.dart';
import '../../features/rooms/rooms.dart';
import '../session/session_notifier.dart';
import 'main_shell.dart';

const _publicRoutes = {LoginPage.routeName, '/register', '/confirm-email'};

final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(SessionNotifier session) {
  return GoRouter(
    initialLocation: HomePage.routeName,
    refreshListenable: session,
    redirect: (context, state) {
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
        path: CreateRoomPage.routeName,
        builder: (context, state) => const CreateRoomPage(),
      ),

      GoRoute(
        path: RoomDetailPage.routeName,
        builder: (context, state) =>
            RoomDetailPage(roomId: int.parse(state.pathParameters['roomId']!)),
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
