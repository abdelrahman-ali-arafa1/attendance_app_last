import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String themeKey = 'is_dark_theme';

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }

  Future<void> toggleTheme() async {
    final currentMode = await isDarkMode();
    await setDarkMode(!currentMode);
  }
}
