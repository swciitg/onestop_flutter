import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class ThemeStore extends ChangeNotifier {
  static final ThemeStore _instance = ThemeStore._internal();
  factory ThemeStore() => _instance;
  ThemeStore._internal() {
    initTheme();
  }

  Brightness _currentTheme = Brightness.light;

  Brightness get currentTheme => _currentTheme;

  bool get isDarkMode => _currentTheme == Brightness.dark;
  bool get isLightMode => _currentTheme == Brightness.light;

  Future<void> initTheme() async {
    _currentTheme = OTheme.currentTheme;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _currentTheme = _currentTheme == Brightness.light ? Brightness.dark : Brightness.light;

    await OTheme.setTheme(_currentTheme);
    notifyListeners();
  }

  Future<void> setTheme(Brightness theme) async {
    _currentTheme = theme;
    await OTheme.setTheme(theme);
    notifyListeners();
  }

  // Theme-aware colors that automatically update
  Color get backgroundColor => isDarkMode ? const Color(0xFF1C1C1E) : OColor.white;
  Color get cardColor => isDarkMode ? const Color(0xFF2C2C2E) : OColor.white;
  Color get surfaceColor => isDarkMode ? const Color(0xFF2C2C2E) : OColor.gray100;
  Color get textColor => isDarkMode ? OColor.white : OColor.gray800;
  Color get subtitleColor => isDarkMode ? const Color(0xFF8E8E93) : OColor.gray600;
  Color get borderColor => isDarkMode ? const Color(0xFF3A3A3C) : OColor.gray200;
  Color get iconColor => isDarkMode ? OColor.white : OColor.gray800;
}
