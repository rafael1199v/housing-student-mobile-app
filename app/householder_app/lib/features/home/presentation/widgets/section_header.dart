import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  
  const SectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
