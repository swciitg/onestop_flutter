import 'dart:developer' as dev;

import 'package:flutter/services.dart';

class AppIconService {
  static const _channel = MethodChannel('com.swciitg.onestop2/app_icon');

  static Future<void> setIcon(String iconName) async {
    try {
      await _channel.invokeMethod('setAlternateIcon', iconName);
      dev.log('App icon switched to: $iconName', name: 'AppIconService');
    } catch (e) {
      dev.log('Failed to switch app icon: $e', name: 'AppIconService');
    }
  }
}
