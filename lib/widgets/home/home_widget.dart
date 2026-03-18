import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class HomeWidget extends StatelessWidget {
  final Widget child;
  const HomeWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OColor.gray200),
        boxShadow: [
          BoxShadow(
            color: OColor.gray300.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
