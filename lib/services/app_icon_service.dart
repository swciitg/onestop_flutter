import 'dart:developer' as dev;

import 'package:flutter/services.dart';

class AppIconService {
  static const _channel = MethodChannel('com.swciitg.onestop2/app_icon');
  static const _restartChannel = MethodChannel('com.swciitg.onestop2/restart');

  static Future<void> setIcon(String iconName) async {
    try {
      await _channel.invokeMethod('setAlternateIcon', iconName);
      dev.log('App icon switched to: $iconName', name: 'AppIconService');
    } catch (e) {
      dev.log('Failed to switch app icon: $e', name: 'AppIconService');
    }
  }

  static Future<void> restartApp() async {
    try {
      await _restartChannel.invokeMethod('restartApp');
    } catch (e) {
      dev.log('Failed to restart app: $e', name: 'AppIconService');
    }
  }
}
