import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'field_label.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.trailing,
    this.suffixIcon,
    this.errorText,
    this.enabled = true,
    this.uppercaseLabel = true,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Widget? trailing;

  final Widget? suffixIcon;
  final String? errorText;
  final bool enabled;
  final bool uppercaseLabel;

  final int maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(
          text: label,
          uppercase: uppercaseLabel,
          trailing: trailing,
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: obscureText ? 1 : maxLines,
          enabled: enabled,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon == null
                ? null
                : Icon(icon, size: 20, color: AppColors.textHint),
            suffixIcon: suffixIcon,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
