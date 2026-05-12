import 'package:flutter/widgets.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/resource/storage_service.dart';

class CartProvider with ChangeNotifier {
  int? productCount;
  bool isUpdateCount = false;
  double totalPrice = 0.0;

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final saved = await StorageService.loadCart();
    Cart().itemsMap = saved;
    totalPrice = saved.entries.fold(0.0, (sum, e) => sum + e.key.price * e.value);
    notifyListeners();
  }

  void _save() => StorageService.saveCart(Cart().itemsMap);

  set setUpdateCount(bool update) => isUpdateCount = update;
  set setTotalPrice(double price) => totalPrice = price;
  set count(int count) => productCount = count;

  incrementCounter(int quantity) {
    count = quantity;
    setUpdateCount = false;
    _save();
    notifyListeners();
  }

  decrementCounter(int quantity) {
    count = quantity;
    setUpdateCount = false;
    _save();
    notifyListeners();
  }

  addPrice(double price) {
    setTotalPrice = totalPrice + price;
    notifyListeners();
  }

  subtractPrice(double price) {
    setTotalPrice = totalPrice - price;
    notifyListeners();
  }
}
