import 'package:flutter/material.dart';

class AnimatedExpand extends StatefulWidget {
  final Widget child;
  final bool expand;
  const AnimatedExpand({super.key, this.expand = false, required this.child});

  @override
  State<AnimatedExpand> createState() => _AnimatedExpandState();
}

class _AnimatedExpandState extends State<AnimatedExpand>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedExpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}
