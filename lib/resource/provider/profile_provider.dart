import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const _nameKey = 'profile_name';

  String name = '';

  ProfileProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(_nameKey) ?? '';
    notifyListeners();
  }

  Future<void> save({required String newName}) async {
    name = newName.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    notifyListeners();
  }

  Future<void> clear() async {
    name = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    notifyListeners();
  }
}
