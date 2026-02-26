import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:quick_actions/quick_actions.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';

class AppShortcutsService {
  static const QuickActions _quickActions = QuickActions();

  /// Initialize app shortcuts
  static Future<void> initialize() async {
    // Define the shortcuts with platform-specific icons
    await _quickActions.setShortcutItems([
      ShortcutItem(
        type: 'gate_log',
        localizedTitle: 'GateLog',
        localizedSubtitle: "Digital Gate Logging",
        icon: Platform.isIOS ? 'door.left.hand.open' : 'ic_gate_log',
      ),
      ShortcutItem(
        type: 'mess_menu',
        localizedTitle: 'Mess Menu',
        localizedSubtitle: "Today's Mess Menu",
        icon: Platform.isIOS ? 'fork.knife' : 'ic_mess_menu',
      ),
      ShortcutItem(
        type: 'time_table',
        localizedTitle: 'Time Table',
        localizedSubtitle: "Today's Time Table",
        icon: Platform.isIOS ? 'calendar' : 'ic_time_table',
      ),
      //
      // ShortcutItem(
      //   type: 'restaurants',
      //   localizedTitle: 'Restaurants',
      //   icon: Platform.isIOS ? 'RestaurantIcon' : 'ic_restaurant',
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
