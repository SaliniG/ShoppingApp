import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'dark_mode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _load();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggle() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    _save();
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = (prefs.getBool(_key) ?? false) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, isDark);
  }
}
