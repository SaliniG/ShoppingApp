import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/modal/ui/order_model.dart';
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

  static const _ordersKey = 'orders_data';

  static Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final data = orders.map((o) => {
      'id': o.id,
      'date': o.date.toIso8601String(),
      'totalPrice': o.totalPrice,
      'paymentMethod': o.paymentMethod,
      'items': o.items.map((i) => {
        'product': _toJson(i.product),
        'quantity': i.quantity,
      }).toList(),
    }).toList();
    await prefs.setString(_ordersKey, json.encode(data));
  }

  static Future<List<OrderModel>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ordersKey);
    if (raw == null) return [];
    final List decoded = json.decode(raw);
    return decoded.map((o) => OrderModel(
      id: o['id'] as String,
      date: DateTime.parse(o['date'] as String),
      totalPrice: (o['totalPrice'] as num).toDouble(),
      paymentMethod: o['paymentMethod'] as String,
      items: (o['items'] as List).map((i) => OrderItem(
        product: ProductModel.fromJson(i['product']),
        quantity: i['quantity'] as int,
      )).toList(),
    )).toList();
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
