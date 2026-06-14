import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../utils/room_tag_resolver.dart';

class AmenitiesGrid extends StatelessWidget {
  final List<RoomTag> serviceTags;
  final List<RoomTag> policyTags;

  const AmenitiesGrid({
    super.key,
    required this.serviceTags,
    required this.policyTags,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasServices = serviceTags.isNotEmpty;
    final hasPolicies = policyTags.isNotEmpty;

    if (!hasServices && !hasPolicies) {
      return Text(
        'No amenities or policies listed.',
        style: theme.textTheme.bodyMedium,
      );
    }

    final headerStyle = theme.textTheme.displaySmall?.copyWith(fontSize: 18);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasServices) ...[
          Text('Amenities', style: headerStyle),
          AppSpacing.gapLg,
          _ServicesGrid(tags: serviceTags),
        ],
        if (hasServices && hasPolicies) ...[
          AppSpacing.gapXl,
          const Divider(height: 1),
          AppSpacing.gapXl,
        ],
        if (hasPolicies) ...[
          Text('Policies', style: headerStyle),
          AppSpacing.gapLg,
          for (var i = 0; i < policyTags.length; i++) ...[
            if (i > 0) AppSpacing.gapMd,
            _PolicyRow(tag: policyTags[i]),
          ],
        ],
      ],
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid({required this.tags});

  final List<RoomTag> tags;

  @override
  Widget build(BuildContext context) {
    const columns = 2;
    const gap = AppSpacing.md;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final tag in tags)
              SizedBox(
                width: itemWidth,
                child: _AmenityTile(tag: tag, singleLine: true),
              ),
          ],
        );
      },
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.tag});

  final RoomTag tag;

  @override
  Widget build(BuildContext context) {
    return _AmenityTile(tag: tag, singleLine: false);
  }
}

class _AmenityTile extends StatelessWidget {
  final RoomTag tag;
  final bool singleLine;

  const _AmenityTile({required this.tag, required this.singleLine});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadii.mdValue),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: singleLine
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Icon(tag.icon, size: 20, color: cs.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              tag.label,
              maxLines: singleLine ? 1 : null,
              overflow: singleLine
                  ? TextOverflow.ellipsis
                  : TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
