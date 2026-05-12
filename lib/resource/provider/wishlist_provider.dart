import 'package:flutter/widgets.dart';
import 'package:shopping_app/data/wishlist.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';

class WishlistProvider with ChangeNotifier {
  bool isWishlisted(ProductModel product) => Wishlist().items.contains(product);

  void toggle(ProductModel product) {
    if (Wishlist().items.contains(product)) {
      Wishlist().items.remove(product);
    } else {
      Wishlist().items.add(product);
    }
    notifyListeners();
  }

  List<ProductModel> get items => Wishlist().items.toList();
}
