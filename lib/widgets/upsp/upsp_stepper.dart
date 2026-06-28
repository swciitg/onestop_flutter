import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// A two-step progress stepper.
///
/// [currentStep] should be 1 or 2.
/// Labels default to 'PROBLEM' / 'YOUR DETAILS' (UPSP flow).
class UPSPStepper extends StatelessWidget {
  final int currentStep;
  final String step1Label;
  final String step2Label;

  const UPSPStepper({
    super.key,
    required this.currentStep,
    this.step1Label = 'PROBLEM',
    this.step2Label = 'YOUR DETAILS',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        children: [
          // Step 1
          _StepCircle(
            stepNumber: 1,
            label: step1Label,
            isActive: currentStep == 1,
            isCompleted: currentStep > 1,
          ),
          // Connecting line
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                height: 2,
                color: currentStep > 1 ? OColor.green600 : OColor.gray200,
              ),
            ),
          ),
          // Step 2
          _StepCircle(
            stepNumber: 2,
            label: step2Label,
            isActive: currentStep == 2,
            isCompleted: currentStep > 2,
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepCircle({
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final bool highlighted = isActive || isCompleted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: highlighted ? OColor.green600 : OColor.gray200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child:
                isCompleted
                    ? Icon(FluentIcons.checkmark_16_filled, size: 14, color: OColor.white)
                    : Text(
                      '$stepNumber',
                      style: OTextStyle.labelMedium.copyWith(
                        color: highlighted ? OColor.white : OColor.gray800,
                        height: 1,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: OSpacing.xs),
        Text(
          label,
          style: OTextStyle.labelXSmall.copyWith(color: OColor.gray800, letterSpacing: 0.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
