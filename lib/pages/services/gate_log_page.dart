import 'package:flutter/material.dart';
import 'package:gate_log/gate_log.dart';
import 'package:onestop_dev/services/home_gatelog_widget_service.dart';

class GateLogPage extends StatelessWidget {
  static const String id = '/gate_log_page';

  const GateLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final destination = args?['destination'] as String?;
    final autoCheckIn = args?['autoCheckIn'] as bool? ?? false;
    return GateLog(
      initialDestination: destination,
      autoCheckIn: autoCheckIn,
      onEntryChanged: (isCheckedOut) {
        HomeGateLogWidgetService.syncGateLogStatus(isCheckedOut: isCheckedOut);
      },
    );
  }
}
