import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/service.dart';

enum SortOption { none, priceLow, priceHigh, ratingHigh }

class ProductProviderClass extends ChangeNotifier {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _productList = [];
  bool isLoading = false;
  bool isSearch = false;
  bool isListView = true;
  String searchQuery = '';
  String? selectedCategory;
  SortOption sortOption = SortOption.none;
  double minPrice = 0;
  double maxPrice = 0;
  double selectedMinPrice = 0;
  double selectedMaxPrice = 0;

  bool get isPriceFiltered =>
      selectedMinPrice > minPrice || selectedMaxPrice < maxPrice;

  bool get getSearchText => isSearch;

  bool get getListViewStatus => isListView;

  List<ProductModel> get productsList => _productList;

  List<String> get categories =>
      _allProducts.map((p) => p.category).toSet().toList()..sort();

  Future<Response> fetchProductDetails() async {
    _allProducts = [];
    _productList = [];
    isSearch = false;
    selectedCategory = null;
    searchQuery = '';
    sortOption = SortOption.none;
    isLoading = true;
    notifyListeners();
    Response response = await Service.fetchProductDetailsData();
    final List responseBody = json.decode(response.body);
    _allProducts = responseBody.map((e) => ProductModel.fromJson(e)).toList();
    _productList = List.from(_allProducts);
    if (_allProducts.isNotEmpty) {
      minPrice = _allProducts.map((p) => p.price).reduce((a, b) => a < b ? a : b);
      maxPrice = _allProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b);
      selectedMinPrice = minPrice;
      selectedMaxPrice = maxPrice;
    }
    isLoading = false;
    notifyListeners();
    return response;
  }

  void setPriceRange(double min, double max) {
    selectedMinPrice = min;
    selectedMaxPrice = max;
    _applyFilters();
  }

  void clearPriceFilter() {
    selectedMinPrice = minPrice;
    selectedMaxPrice = maxPrice;
    _applyFilters();
  }

  void setSort(SortOption option) {
    sortOption = option;
    _applyFilters();
  }

  void setCategory(String? category) {
    selectedCategory = category;
    _applyFilters();
  }

  void setResults(List<ProductModel> products, String searchString) {
    searchQuery = searchString;
    isSearch = true;
    _applyFilters();
  }

  void clearSearch() {
    searchQuery = '';
    isSearch = false;
    _applyFilters();
  }

  void _applyFilters() {
    List<ProductModel> result = _allProducts;

    if (selectedCategory != null) {
      result = result.where((p) => p.category == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedMaxPrice > 0) {
      result = result
          .where((p) => p.price >= selectedMinPrice && p.price <= selectedMaxPrice)
          .toList();
    }

    if (sortOption == SortOption.priceLow) {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == SortOption.priceHigh) {
      result.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortOption == SortOption.ratingHigh) {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    _productList = result;
    notifyListeners();
  }
}
