import 'package:flutter/widgets.dart';
import 'package:shopping_app/data/wishlist.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/storage_service.dart';

class WishlistProvider with ChangeNotifier {
  WishlistProvider() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final saved = await StorageService.loadWishlist();
    Wishlist().items
      ..clear()
      ..addAll(saved);
    notifyListeners();
  }

  void _save() => StorageService.saveWishlist(Wishlist().items);

  bool isWishlisted(ProductModel product) => Wishlist().items.contains(product);

  void toggle(ProductModel product) {
    if (Wishlist().items.contains(product)) {
      Wishlist().items.remove(product);
    } else {
      Wishlist().items.add(product);
    }
    _save();
    notifyListeners();
  }

  List<ProductModel> get items => Wishlist().items.toList();
}
