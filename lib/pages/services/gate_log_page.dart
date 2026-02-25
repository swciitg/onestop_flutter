import 'package:flutter/material.dart';
import 'package:gate_log/gate_log.dart';

class GateLogPage extends StatelessWidget {
  static const String id = '/gate_log_page';

  const GateLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final destination = args?['destination'] as String?;
    return GateLog(initialDestination: destination);
  }
}
