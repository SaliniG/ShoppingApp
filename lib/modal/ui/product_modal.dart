class ProductModel {
  String name;
  String description;
  String imageUrl;
  double price;

  ProductModel(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.price});

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }

  //override equality object for the item
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          price == other.price;

  @override
  int get hashCode =>
      name.hashCode ^ description.hashCode ^ imageUrl.hashCode ^ price.hashCode;
}
