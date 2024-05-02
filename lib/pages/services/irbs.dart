import 'package:flutter/material.dart';
import 'package:irbs/irbs.dart';

class IRBSPage extends StatelessWidget {
  static const String id = '/irbs';
  const IRBSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IRBS();
  }
}
