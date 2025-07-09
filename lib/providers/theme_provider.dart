import 'package:craftworks_app/services/preferences_services.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    if (PreferencesServices.containsKey('isDarkMode')) {
      final isDark = PreferencesServices.getBool('isDarkMode')!;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    await PreferencesServices.setBool('isDarkMode', isDark);
    notifyListeners();
  }
}
