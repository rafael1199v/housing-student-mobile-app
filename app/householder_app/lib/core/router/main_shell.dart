import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        backgroundColor: cs.surfaceContainerLowest,
        indicatorColor: cs.primary.withValues(alpha: 0.12),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home, color: cs.primary),
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            label: 'Messages',
            selectedIcon: Icon(Icons.chat_bubble, color: cs.primary),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            label: 'Profile',
            selectedIcon: Icon(Icons.person, color: cs.primary),
          )
        ],
      ),
    );
  }
}
