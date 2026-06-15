import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int stepCount;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.stepCount = 3,
  });


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var i = 0; i < stepCount; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 5,
              decoration: BoxDecoration(
                color: i <= currentStep ? cs.primary : cs.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadii.pillValue),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
