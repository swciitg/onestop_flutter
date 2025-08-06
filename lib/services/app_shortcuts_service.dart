import 'dart:async';
import 'dart:developer';
import 'package:quick_actions/quick_actions.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';

class AppShortcutsService {
  static const QuickActions _quickActions = QuickActions();

  /// Initialize app shortcuts
  static Future<void> initialize() async {
    // Define the shortcuts
    await _quickActions.setShortcutItems([
      const ShortcutItem(
        type: 'gate_log',
        localizedTitle: 'GateLog',
        localizedSubtitle: "Digital Gate Logging",
        icon: 'ic_gate_log',
      ),
      const ShortcutItem(
        type: 'mess_menu',
        localizedTitle: 'Mess Menu',
        localizedSubtitle: "Today's Mess Menu",
        icon: 'ic_mess_menu',
      ),
      const ShortcutItem(
        type: 'time_table',
        localizedTitle: 'Time Table',
        localizedSubtitle: "Today's Time Table",
        icon: 'ic_time_table',
      ),
      // You can add more shortcuts here
      // const ShortcutItem(
      //   type: 'restaurants',
      //   localizedTitle: 'Restaurants',
      //   icon: 'ic_restaurant',
      // ),
    ]);

    // Handle shortcut actions
    _quickActions.initialize((shortcutType) {
      _handleShortcutAction(shortcutType);
    });
  }

  /// Handle shortcut actions
  static void _handleShortcutAction(String shortcutType) async {
    _pendingShortcutAction = shortcutType;
  }

  static void shortcutActionHelper(String action, Function(int) updateTab) {
    switch (action) {
      case 'gate_log':
        navigatorKey.currentState?.pushNamed(GateLogPage.id);
        break;
      case 'mess_menu':
        updateTab(1);
        break;
      case 'time_table':
        updateTab(3);
        break;
      default:
        break;
    }
  }

  /// Handle pending shortcut action after app initialization
  static String? _pendingShortcutAction;

  static void handlePendingShortcutAction(Function(int) updateTab) {
    if (!hasPendingAction) {
      log("No pending shortcut action", name: 'AppShortcutsService');
      return;
    }
    final action = _pendingShortcutAction!;
    log("Handling pending shortcut action: $action", name: 'AppShortcutsService');
    _pendingShortcutAction = null;

    shortcutActionHelper(action, updateTab);
  }

  /// Check if there's a pending shortcut action
  static bool get hasPendingAction => _pendingShortcutAction != null;

  /// Get the pending shortcut action
  static String? get pendingAction => _pendingShortcutAction;
}
