import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Step indicator for multi-step forms: numbered circles joined by lines, with
/// each step name centred under its circle.
///
/// Completed steps show a check, the current step is filled green and later
/// steps are grey. Matches the Figma "Progress Steps" component (node 1780-57933).
class StepProgressIndicator extends StatelessWidget {
  static const double _circleSize = 24;
  static const double _labelHeight = 20;

  final int numberOfSteps;
  final int currentStep;
  final List<String> stepNames;

  const StepProgressIndicator({
    super.key,
    required this.numberOfSteps,
    required this.currentStep,
    required this.stepNames,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Leaves room for the first/last labels to overhang their circles.
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: OSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < numberOfSteps; i++) ...[
            if (i > 0)
              Expanded(
                child: SizedBox(
                  height: _circleSize,
                  child: Center(
                    child: Container(
                      height: 2,
                      color: i < currentStep ? OColor.green600 : OColor.gray200,
                    ),
                  ),
                ),
              ),
            _buildStep(i),
          ],
        ],
      ),
    );
  }

  Widget _buildStep(int index) {
    final isCompleted = index < currentStep - 1;
    final isCurrent = index == currentStep - 1;

    return Column(
      children: [
        Container(
          width: _circleSize,
          height: _circleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isCompleted || isCurrent ? OColor.green600 : OColor.gray200,
            shape: BoxShape.circle,
          ),
          child:
              isCompleted
                  ? const Icon(
                    FluentIcons.checkmark_16_regular,
                    color: Colors.white,
                    size: 16,
                  )
                  : OText(
                    text: '${index + 1}',
                    style: OTextStyle.labelMedium.copyWith(
                      color: isCurrent ? Colors.white : OColor.gray800,
                      height: 1,
                    ),
                  ),
        ),
        const SizedBox(height: OSpacing.xs),
        // Circle-wide box whose text overflows equally on both sides, so the
        // label stays centred under the number whatever its length.
        SizedBox(
          width: _circleSize,
          height: _labelHeight,
          child: OverflowBox(
            maxWidth: double.infinity,
            child: OText(
              text: stepNames[index].toUpperCase(),
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: OTextStyle.labelXSmall.copyWith(
                color: isCompleted || isCurrent ? OColor.black : OColor.gray800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
