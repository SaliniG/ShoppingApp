import 'package:flutter/material.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';

class CompareProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isFull => _items.length >= 2;
  bool get isReady => _items.length == 2;

  bool contains(ProductModel product) => _items.contains(product);

  void toggle(ProductModel product) {
    if (_items.contains(product)) {
      _items.remove(product);
    } else if (!isFull) {
      _items.add(product);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
