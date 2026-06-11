import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/property_summary.dart';
import '../../domain/entities/room_status.dart';
import '../utils/room_status_label.dart';

class PropertyCard extends StatefulWidget {
  final PropertySummary property;
  final VoidCallback onManage;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onManage,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool _descriptionExpanded = false;

  ({Color fg, Color bg}) _badgeColors(RoomStatus status) {
    switch (status) {
      case RoomStatus.available:
        return (fg: AppColors.success, bg: AppColors.successSurface);
      case RoomStatus.booked:
        return (fg: AppColors.accent, bg: AppColors.accentSurface);
      case RoomStatus.unavailable:
      case RoomStatus.unknown:
        return (fg: AppColors.textSecondary, bg: AppColors.neutralSurface);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final property = widget.property;
    final colors = _badgeColors(property.status);
    final pending = property.pendingRequests;
    final description = property.description.trim();

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Cover(
            imageUrl: property.imageUrl,
            badge: StatusBadge(
              label: roomStatusLabel(context, property.status),
              foregroundColor: colors.fg,
              backgroundColor: colors.bg,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.name,
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 18),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _Description(
                    text: description,
                    expanded: _descriptionExpanded,
                    onToggle: () => setState(
                      () => _descriptionExpanded = !_descriptionExpanded,
                    ),
                  ),
                ],
                AppSpacing.gapM,
                const Divider(height: 1),
                AppSpacing.gapM,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$pending booking request${pending == 1 ? '' : 's'}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onManage,
                      child: Text(
                        'Manage Room',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  static const _collapsedMaxLines = 2;

  final String text;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final overflows = _overflows(text, style, constraints.maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              maxLines: expanded ? null : _collapsedMaxLines,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: style,
            ),
            if (overflows) ...[
              const SizedBox(height: AppSpacing.xxs),
              GestureDetector(
                onTap: onToggle,
                child: Text(
                  expanded ? 'Show less' : 'Show more',
                  style: style?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  bool _overflows(String text, TextStyle? style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: _collapsedMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.imageUrl, required this.badge});

  final String? imageUrl;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusL),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: imageUrl == null
                ? const _CoverPlaceholder()
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const _CoverPlaceholder(loading: true);
                    },
                    errorBuilder: (_, _, _) => const _CoverPlaceholder(),
                  ),
          ),
          Positioned(top: AppSpacing.s, left: AppSpacing.s, child: badge),
        ],
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({this.loading = false});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.fieldFill,
      child: Center(
        child: loading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : const Icon(
                Icons.image_outlined,
                size: 40,
                color: AppColors.textHint,
              ),
      ),
    );
  }
}
