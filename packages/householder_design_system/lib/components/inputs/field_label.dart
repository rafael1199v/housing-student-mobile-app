import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.text,
    this.uppercase = false,
    this.trailing,
  });

  final String text;
  final bool uppercase;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final style = uppercase
        ? Theme.of(context).textTheme.labelSmall
        : Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 0,
              fontSize: 13,
              color: AppColors.textPrimary,
            );

    return Row(
      children: [
        Expanded(child: Text(uppercase ? text.toUpperCase() : text, style: style)),
        ?trailing,
      ],
    );
  }
}
