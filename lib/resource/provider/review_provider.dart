import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/modal/ui/review_model.dart';

class ReviewProvider extends ChangeNotifier {
  static const _key = 'reviews_data';
  Map<String, List<ReviewModel>> _reviews = {};

  ReviewProvider() {
    _load();
  }

  List<ReviewModel> forProduct(String productId) =>
      _reviews[productId] ?? [];

  Future<void> addReview(ReviewModel review) async {
    _reviews.putIfAbsent(review.productId, () => []);
    _reviews[review.productId]!.insert(0, review);
    await _save();
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final Map<String, dynamic> decoded = json.decode(raw);
    _reviews = decoded.map((k, v) => MapEntry(
          k,
          (v as List).map((e) => ReviewModel.fromJson(e)).toList(),
        ));
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _reviews.map((k, v) => MapEntry(k, v.map((r) => r.toJson()).toList()));
    await prefs.setString(_key, json.encode(data));
  }
}
