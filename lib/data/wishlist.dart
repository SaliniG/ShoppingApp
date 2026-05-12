import 'package:shopping_app/modal/ui/product_modal.dart';

class Wishlist {
  static final Wishlist _instance = Wishlist._internal();

  final Set<ProductModel> items = {};

  factory Wishlist() => _instance;

  Wishlist._internal();
}
