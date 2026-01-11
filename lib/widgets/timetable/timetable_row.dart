import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/ui/animated_expand.dart';

class TimetableRow extends StatelessWidget {
  final bool expanded;
  const TimetableRow({super.key, required this.classes, required this.expanded});

  final List<Widget> classes;

  @override
  Widget build(BuildContext context) {
    return AnimatedExpand(
      expand: expanded,
      child: Column(
        children:
            classes
                .map(
                  (e) => Row(
                    children: [
                      const Expanded(flex: 10, child: SizedBox()),
                      Expanded(flex: 36, child: e),
                      const SizedBox(width: 8),
                      const Expanded(flex: 7, child: SizedBox()),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
