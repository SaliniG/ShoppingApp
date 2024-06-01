import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/service.dart';

class ProductProviderClass extends ChangeNotifier {
  List<ProductModel> _productList = [];
  bool isSearch = false;
  bool isListView = true;
  String searchQuery = "";
  List productList = [];

  bool get getSearchText => isSearch;

  set setSearchText(bool status) {
    isSearch = status;
    notifyListeners();
  }

  String get getSearchQuery => searchQuery;

  //setter to set search text by name
  set setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  bool get getListViewStatus => isListView;

  List<ProductModel> get productsList => _productList;

  //setter to set product list
  set setProductsList(List<ProductModel> value) {
    _productList = value;
  }

//function to return  json object from api call
  Future<Response> fetchProductDetails() async {
    try {
      setProductsList = [];
      setSearchText = false;
      Response response = await Service.fetchProductDetailsData();
      final List responseBody = json.decode(response.body);
      setProductsList = responseBody
          .map((e) => ProductModel.fromJson(e))
          .toList(); //set response to modal class
      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

//function to return  json object  by name
  setResults(List<ProductModel> products, String searchString) {
    setSearchQuery = searchString;
    //checking search contains in the product list
    final List<ProductModel> responseBody = products
        .where((elem) => elem.name
            .toString()
            .toLowerCase()
            .contains(searchString.toLowerCase()))
        .toList();
    setProductsList = responseBody;
    notifyListeners();
  }
}
