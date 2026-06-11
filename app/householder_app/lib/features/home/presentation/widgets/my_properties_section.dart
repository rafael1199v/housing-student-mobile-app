import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/property_summary.dart';
import 'property_card.dart';
import 'section_header.dart';

class MyPropertiesSection extends StatelessWidget {
  const MyPropertiesSection({
    super.key,
    required this.properties,
    required this.onManage,
  });

  final List<PropertySummary> properties;
  final void Function(PropertySummary property) onManage;

  static const double _minCardWidth = 300;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'My Properties'),
        AppSpacing.gapM,
        if (properties.isEmpty) _EmptyProperties() else _buildGrid(),
      ],
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.m;
        final maxWidth = constraints.maxWidth;
        final columns = (maxWidth / _minCardWidth).floor().clamp(1, 3);
        final cardWidth =
            (maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final property in properties)
              SizedBox(
                width: cardWidth,
                child: PropertyCard(
                  property: property,
                  onManage: () => onManage(property),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyProperties extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(Icons.home_outlined, size: 40, color: AppColors.textHint),
          AppSpacing.gapS,
          Text(
            "You haven't listed any rooms yet.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
