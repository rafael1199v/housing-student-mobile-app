import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';


class ThemeModeSelector extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const ThemeModeSelector({super.key, required this.onSelect});

  static const _options = <({String label, IconData icon})>[
    (label: 'System', icon: Icons.settings_suggest_outlined),
    (label: 'Light', icon: Icons.light_mode_outlined),
    (label: 'Dark', icon: Icons.dark_mode_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.mdValue),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _options.length; i++)
            Expanded(
              child: _Segment(
                label: _options[i].label,
                icon: _options[i].icon,
                selected: i == 0,
                onTap: () => onSelect(_options[i].label),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = selected ? cs.primary : cs.onSurfaceVariant;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? cs.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.smValue),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
