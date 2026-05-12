import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryProvider extends ChangeNotifier {
  static const _key = 'search_history';
  static const _maxItems = 8;
  List<String> _history = [];

  SearchHistoryProvider() {
    _load();
  }

  List<String> get history => List.unmodifiable(_history);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList(_key) ?? [];
    notifyListeners();
  }

  Future<void> add(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    _history.remove(q);
    _history.insert(0, q);
    if (_history.length > _maxItems) _history = _history.sublist(0, _maxItems);
    await _save();
    notifyListeners();
  }

  Future<void> remove(String query) async {
    _history.remove(query);
    await _save();
    notifyListeners();
  }

  Future<void> clear() async {
    _history.clear();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _history);
  }
}
