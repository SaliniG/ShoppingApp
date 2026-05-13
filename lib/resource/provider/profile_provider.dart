import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';

  String name = '';
  String email = '';

  ProfileProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(_nameKey) ?? '';
    email = prefs.getString(_emailKey) ?? '';
    notifyListeners();
  }

  Future<void> save({required String newName, required String newEmail}) async {
    name = newName.trim();
    email = newEmail.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    notifyListeners();
  }
}
