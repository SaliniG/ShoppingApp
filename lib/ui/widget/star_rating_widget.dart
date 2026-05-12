import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final int count;
  final double size;
  final bool showCount;
  final Color? textColor;

  const StarRatingWidget({
    required this.rating,
    required this.count,
    this.size = 14,
    this.showCount = true,
    this.textColor = Colors.white70,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) {
            return Icon(Icons.star, color: Colors.amber, size: size);
          } else if (i < rating && rating - i >= 0.5) {
            return Icon(Icons.star_half, color: Colors.amber, size: size);
          } else {
            return Icon(Icons.star_border, color: Colors.amber, size: size);
          }
        }),
        if (showCount) ...[
          const SizedBox(width: 4),
          Text(
            '${rating.toStringAsFixed(1)} ($count)',
            style: TextStyle(fontSize: size - 2, color: textColor),
          ),
        ],
      ],
    );
  }
}
