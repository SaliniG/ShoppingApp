import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';

class StorageService {
  static const _cartKey = 'cart_data';
  static const _wishlistKey = 'wishlist_data';

  static Future<void> saveCart(Map<ProductModel, int> cartMap) async {
    final prefs = await SharedPreferences.getInstance();
    final data = cartMap.entries
        .map((e) => {'product': _toJson(e.key), 'quantity': e.value})
        .toList();
    await prefs.setString(_cartKey, json.encode(data));
  }

  static Future<Map<ProductModel, int>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null) return {};
    final List decoded = json.decode(raw);
    final Map<ProductModel, int> result = {};
    for (final item in decoded) {
      result[ProductModel.fromJson(item['product'])] = item['quantity'] as int;
    }
    return result;
  }

  static Future<void> saveWishlist(Set<ProductModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final data = items.map((p) => _toJson(p)).toList();
    await prefs.setString(_wishlistKey, json.encode(data));
  }

  static Future<Set<ProductModel>> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_wishlistKey);
    if (raw == null) return {};
    final List decoded = json.decode(raw);
    return decoded
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toSet();
  }

  static Map<String, dynamic> _toJson(ProductModel p) => {
        'title': p.name,
        'description': p.description,
        'image': p.imageUrl,
        'price': p.price,
        'category': p.category,
        'rating': {'rate': p.rating, 'count': p.ratingCount},
      };
}
