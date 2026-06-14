import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String? imageUrl;
  final VoidCallback onEditPhoto;
  final bool isUploading;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.onEditPhoto,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _Avatar(
          imageUrl: imageUrl,
          onEditPhoto: onEditPhoto,
          isUploading: isUploading,
        ),
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
  const _Avatar({
    required this.imageUrl,
    required this.onEditPhoto,
    required this.isUploading,
  });

  static const _size = 104.0;
  static const _badgeSize = 34.0;

  final String? imageUrl;
  final VoidCallback onEditPhoto;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final url = imageUrl?.trim() ?? '';
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
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
          if (isUploading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
                child: Center(
                  child: SizedBox.square(
                    dimension: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(cs.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: -2,
            bottom: -2,
            child: _CameraBadge(
              onTap: isUploading ? null : onEditPhoto,
              size: _badgeSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraBadge extends StatelessWidget {
  const _CameraBadge({required this.onTap, required this.size});

  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.primary,
      shape: CircleBorder(
        side: BorderSide(color: cs.surface, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.photo_camera_outlined,
            size: 18,
            color: cs.onPrimary,
          ),
        ),
      ),
    );
  }
}
