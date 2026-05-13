import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/resource/provider/compare_provider.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/modal/ui/review_model.dart';
import 'package:shopping_app/resource/provider/cart_provider.dart';
import 'package:shopping_app/resource/provider/profile_provider.dart';
import 'package:shopping_app/resource/provider/review_provider.dart';
import 'package:shopping_app/resource/provider/wishlist_provider.dart';
import 'package:shopping_app/ui/widget/star_rating_widget.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/utils/styles.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatefulWidget {
  static const routerPath = '/articlesDetailsScreen';
  ProductModel productModel;

  ProductDetailsScreen({required this.productModel, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late CartProvider cartProvider;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.productCount = Cart().itemsMap[widget.productModel] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Product Details',
          style: headlineTextStyleSemiBold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Consumer<CompareProvider>(
            builder: (context, compare, _) {
              final inCompare = compare.contains(widget.productModel);
              final canAdd = !compare.isFull || inCompare;
              return IconButton(
                icon: Icon(
                  Icons.compare_arrows,
                  color: inCompare ? brandColor : null,
                ),
                tooltip: inCompare ? 'Remove from compare' : 'Add to compare',
                onPressed: canAdd
                    ? () {
                        compare.toggle(widget.productModel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(inCompare
                                ? 'Removed from compare'
                                : compare.isReady
                                    ? 'Ready to compare! Tap the bar below.'
                                    : 'Added to compare. Select one more product.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    : null,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: () {
              final product = widget.productModel;
              Share.share(
                '🛍️ ${product.name}\n\$${product.price.toStringAsFixed(2)}\n\nCheck it out on Shopping App!',
                subject: product.name,
              );
            },
          ),
          Consumer<WishlistProvider>(
            builder: (context, wishlist, _) {
              final isWishlisted = wishlist.isWishlisted(widget.productModel);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: brandColor,
                ),
                onPressed: () {
                  wishlist.toggle(widget.productModel);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(isWishlisted
                        ? 'Removed from wishlist'
                        : 'Added to wishlist ❤️'),
                    duration: const Duration(seconds: 2),
                  ));
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image(
                    height: 160,
                    fit: BoxFit.contain,
                    image: NetworkImage(widget.productModel.imageUrl),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productModel.name,
                      style: headlineTextStyleSemiBold,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${AppConstants.dollarText}${widget.productModel.price.toStringAsFixed(2)}",
                          style: headlineTextStyleBold,
                        ),
                        const Spacer(),
                        StarRatingWidget(
                          rating: widget.productModel.rating,
                          count: widget.productModel.ratingCount,
                          size: 16,
                          textColor: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.productModel.description,
                      style: autoCompleteTextStyle,
                    ),
                    const SizedBox(height: 24),
                    Consumer<CartProvider>(
                      builder: (context, value, child) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Cart cart = Cart();
                              ProductModel product = widget.productModel;
                              int currentValue = cart.itemsMap[product] ?? 0;
                              cart.itemsMap[product] = currentValue + 1;
                              value.incrementCounter(currentValue + 1);
                              value.addPrice(widget.productModel.price);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Added to cart 🛒'),
                                duration: Duration(seconds: 2),
                              ));
                            },
                            icon: const Icon(Icons.add_shopping_cart, color: kTextColor),
                            label: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "${value.productCount} in cart",
                            style: headlineTextStyleSemiBold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    _ReviewSection(productId: widget.productModel.name),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewSection extends StatefulWidget {
  final String productId;
  const _ReviewSection({required this.productId});

  @override
  State<_ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<_ReviewSection> {
  final _commentController = TextEditingController();
  int _selectedRating = 5;
  bool _showForm = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;
    final author = Provider.of<ProfileProvider>(context, listen: false).name;
    Provider.of<ReviewProvider>(context, listen: false).addReview(
      ReviewModel(
        productId: widget.productId,
        author: author.isEmpty ? 'Anonymous' : author,
        rating: _selectedRating,
        comment: comment,
        date: DateTime.now(),
      ),
    );
    _commentController.clear();
    setState(() { _showForm = false; _selectedRating = 5; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted!'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, _) {
        final reviews = reviewProvider.forProduct(widget.productId);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Reviews (${reviews.length})', style: headlineTextStyleSemiBold),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => setState(() => _showForm = !_showForm),
                  icon: Icon(_showForm ? Icons.close : Icons.rate_review_outlined,
                      color: brandColor, size: 18),
                  label: Text(_showForm ? 'Cancel' : 'Write a review',
                      style: const TextStyle(color: brandColor)),
                ),
              ],
            ),
            if (_showForm) ...[
              const SizedBox(height: 8),
              // Star selector
              Row(
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setState(() => _selectedRating = i + 1),
                  child: Icon(
                    i < _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 28,
                  ),
                )),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No reviews yet. Be the first!',
                    style: TextStyle(color: Colors.grey)),
              )
            else
              ...reviews.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(r.author,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            const Spacer(),
                            ...List.generate(5, (i) => Icon(
                                  i < r.rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber, size: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(r.comment, style: autoCompleteTextStyle),
                        const SizedBox(height: 2),
                        Text(
                          '${r.date.day}/${r.date.month}/${r.date.year}',
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        const Divider(),
                      ],
                    ),
                  )),
          ],
        );
      },
    );
  }
}
