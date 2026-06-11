import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

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
    if (serviceTags.isEmpty && policyTags.isEmpty) {
      return Text(
        'No amenities or policies listed.',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (serviceTags.isNotEmpty) _ServicesGrid(tags: serviceTags),
        if (serviceTags.isNotEmpty && policyTags.isNotEmpty) AppSpacing.gapS,
        for (var i = 0; i < policyTags.length; i++) ...[
          if (i > 0) AppSpacing.gapS,
          _PolicyRow(tag: policyTags[i]),
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
    const gap = AppSpacing.s;
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: singleLine
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Icon(tag.icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.s),
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
