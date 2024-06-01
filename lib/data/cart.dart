import 'dart:collection';
import 'dart:ffi';

import 'package:shopping_app/modal/ui/product_modal.dart';

//Singleton class for cart item object one instance
class Cart {
  static final Cart _cart = Cart._internal();

  Map<ProductModel, int> itemsMap = {};

  factory Cart() {
    return _cart;
  }

  Cart._internal();
}
