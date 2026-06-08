import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../features/home/home.dart';
import '../session/session_notifier.dart';

const _publicRoutes = {LoginPage.routeName, '/register', '/confirm-email'};

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
        path: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      )
    ],
  );
}
