class ProductModel {
  String name;
  String description;
  String imageUrl;
  double price;
  String category;
  double rating;
  int ratingCount;

  ProductModel(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.category,
      this.rating = 0.0,
      this.ratingCount = 0});

  static ProductModel fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'] as Map<String, dynamic>?;
    return ProductModel(
      name: json['title'] ?? json['name'],
      description: json['description'],
      imageUrl: json['image'] ?? json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      rating: ratingMap != null ? (ratingMap['rate'] as num).toDouble() : 0.0,
      ratingCount: ratingMap != null ? ratingMap['count'] as int : 0,
    );
  }

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
