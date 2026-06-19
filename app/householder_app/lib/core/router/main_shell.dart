import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../core.dart';

typedef _NavItem = ({IconData icon, IconData selectedIcon, String label});

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  List<_NavItem> _items(AppLocalizations l10n) => [
    (icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.navHome),
    (
      icon: Icons.chat_bubble_outline,
      selectedIcon: Icons.chat_bubble,
      label: l10n.navMessages,
    ),
    (
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: l10n.navProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final items = _items(l10n);
    final isExpanded =
        Breakpoints.of(MediaQuery.sizeOf(context).width) == WindowSize.expanded;

    if (isExpanded) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              backgroundColor: cs.surfaceContainerLowest,
              indicatorColor: cs.primary.withValues(alpha: 0.12),
              destinations: [
                for (final item in items)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon, color: cs.primary),
                    label: Text(item.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        backgroundColor: cs.surfaceContainerLowest,
        indicatorColor: cs.primary.withValues(alpha: 0.12),
        destinations: [
          for (final item in items)
            NavigationDestination(
              icon: Icon(item.icon),
              label: item.label,
              selectedIcon: Icon(item.selectedIcon, color: cs.primary),
            ),
        ],
      ),
    );
  }
}
