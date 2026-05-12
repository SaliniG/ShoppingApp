import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/provider/cart_provider.dart';
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
          Consumer<WishlistProvider>(
            builder: (context, wishlist, _) {
              final isWishlisted = wishlist.isWishlisted(widget.productModel);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: brandColor,
                ),
                onPressed: () => wishlist.toggle(widget.productModel),
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
