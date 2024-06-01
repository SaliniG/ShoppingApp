import 'dart:developer';

import 'package:flutter/widgets.dart';

class CartProvider with ChangeNotifier {
  int? productCount;
  bool isUpdateCount = false;
  double totalPrice = 0.0;

  //setter for update tem count
  set setUpdateCount(bool update) {
    isUpdateCount = update;
  }

  //setter for total price
  set setTotalPrice(double price) {
    totalPrice = price;
  }

  set count(int count) {
    productCount = count;
  }

  //increment cart item
  incrementCounter(int quantity) {
    count = quantity++;

    setUpdateCount = false;

    notifyListeners();
  }

  //decrement cart item
  decrementCounter(int quantity) {
    count = quantity--;
    setUpdateCount = false;
    notifyListeners();
  }

  //adding cart item price
  addPrice(double price) {
    log("message::   $price");
    setTotalPrice = totalPrice + price;
    notifyListeners();
  }

  //subtracting cart item price
  subtractPrice(double price) {
    setTotalPrice = totalPrice - price;
    notifyListeners();
  }
}
