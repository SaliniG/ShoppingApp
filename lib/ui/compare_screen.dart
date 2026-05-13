import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/provider/compare_provider.dart';
import 'package:shopping_app/ui/widget/star_rating_widget.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/styles.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<CompareProvider>(context).items;
    final a = products[0];
    final b = products[1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Products', style: headlineTextStyleSemiBold),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Provider.of<CompareProvider>(context, listen: false).clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Table(
            border: TableBorder.all(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              // Header row
              _headerRow(context, a, b),
              // Image row
              _imageRow(a, b),
              // Price row
              _row('Price',
                  '\$${a.price.toStringAsFixed(2)}',
                  '\$${b.price.toStringAsFixed(2)}',
                  highlight: _lower(a.price, b.price)),
              // Rating row
              _ratingRow(a, b),
              // Category row
              _row('Category', a.category, b.category),
              // Reviews row
              _row('Reviews',
                  '${a.ratingCount}',
                  '${b.ratingCount}',
                  highlight: _higher(a.ratingCount.toDouble(), b.ratingCount.toDouble())),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _headerRow(BuildContext context, ProductModel a, ProductModel b) {
    return TableRow(
      decoration: BoxDecoration(color: brandColor.withAlpha(30)),
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text('', style: titleTextStyle),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(a.name,
              style: titleTextStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(b.name,
              style: titleTextStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  TableRow _imageRow(ProductModel a, ProductModel b) {
    return TableRow(children: [
      const SizedBox(),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Image.network(a.imageUrl, height: 90, fit: BoxFit.contain),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Image.network(b.imageUrl, height: 90, fit: BoxFit.contain),
      ),
    ]);
  }

  TableRow _row(String label, String valA, String valB, {int highlight = 0}) {
    return TableRow(children: [
      _labelCell(label),
      _valueCell(valA, highlighted: highlight == 1),
      _valueCell(valB, highlighted: highlight == 2),
    ]);
  }

  TableRow _ratingRow(ProductModel a, ProductModel b) {
    final better = _higher(a.rating, b.rating);
    return TableRow(children: [
      _labelCell('Rating'),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          color: better == 1 ? Colors.green.withAlpha(30) : null,
          child: StarRatingWidget(rating: a.rating, count: 0, showCount: false, size: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          color: better == 2 ? Colors.green.withAlpha(30) : null,
          child: StarRatingWidget(rating: b.rating, count: 0, showCount: false, size: 14),
        ),
      ),
    ]);
  }

  Widget _labelCell(String text) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12,
                color: Colors.grey)),
      );

  Widget _valueCell(String text, {bool highlighted = false}) => Container(
        color: highlighted ? Colors.green.withAlpha(30) : null,
        padding: const EdgeInsets.all(10),
        child: Text(text, style: titleTextStyle),
      );

  // Returns 1 if a is lower (better for price), 2 if b is lower, 0 if equal
  int _lower(double a, double b) => a < b ? 1 : (b < a ? 2 : 0);
  // Returns 1 if a is higher (better for rating/reviews), 2 if b is higher
  int _higher(double a, double b) => a > b ? 1 : (b > a ? 2 : 0);
}
