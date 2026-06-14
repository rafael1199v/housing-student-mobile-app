import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String? imageUrl;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _Avatar(imageUrl: imageUrl, onEdit: onEdit),
        AppSpacing.gapLg,
        Text(
          fullName,
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall?.copyWith(fontSize: 28),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          email,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.onEdit});

  static const _size = 104.0;

  final String? imageUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final url = imageUrl?.trim() ?? '';
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        children: [
          Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surfaceContainerLow,
              border: Border.all(color: cs.surfaceContainerLowest, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: url.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 52,
                      color: cs.outline,
                    )
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.person,
                        size: 52,
                        color: cs.outline,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
