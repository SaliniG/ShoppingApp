class ReviewModel {
  final String productId;
  final String author;
  final int rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.productId,
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'author': author,
        'rating': rating,
        'comment': comment,
        'date': date.toIso8601String(),
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        productId: json['productId'] as String,
        author: json['author'] as String,
        rating: json['rating'] as int,
        comment: json['comment'] as String,
        date: DateTime.parse(json['date'] as String),
      );
}
