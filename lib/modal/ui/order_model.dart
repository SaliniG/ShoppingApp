import 'package:shopping_app/modal/ui/product_modal.dart';

class OrderItem {
  final ProductModel product;
  final int quantity;

  OrderItem({required this.product, required this.quantity});
}

class OrderModel {
  final String id;
  final DateTime date;
  final double totalPrice;
  final String paymentMethod;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.date,
    required this.totalPrice,
    required this.paymentMethod,
    required this.items,
  });
}
