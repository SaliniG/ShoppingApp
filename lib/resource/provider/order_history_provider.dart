import 'package:flutter/material.dart';
import 'package:shopping_app/modal/ui/order_model.dart';
import 'package:shopping_app/resource/storage_service.dart';

class OrderHistoryProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];

  OrderHistoryProvider() {
    _load();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);

  Future<void> _load() async {
    _orders = await StorageService.loadOrders();
    notifyListeners();
  }

  Future<void> addOrder(OrderModel order) async {
    _orders.insert(0, order);
    await StorageService.saveOrders(_orders);
    notifyListeners();
  }
}
