import 'package:shopping_app/modal/ui/product_modal.dart';

class Cart {
  static final Cart _cart = Cart._internal();

  Map<ProductModel, int> itemsMap = {};

  factory Cart() => _cart;

  Cart._internal();
}
