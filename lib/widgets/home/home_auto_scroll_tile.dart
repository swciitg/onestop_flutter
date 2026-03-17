import 'dart:async';
import 'package:flutter/material.dart';

class HomeAutoScrollTile extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;

  const HomeAutoScrollTile({
    super.key,
    required this.children,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<HomeAutoScrollTile> createState() => _HomeAutoScrollTileState();
}

class _HomeAutoScrollTileState extends State<HomeAutoScrollTile> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.children.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_currentIndex),
        child: widget.children[_currentIndex],
      ),
    );
  }
}
