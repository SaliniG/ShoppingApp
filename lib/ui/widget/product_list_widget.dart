import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/provider/product_provider.dart';
import 'package:shopping_app/resource/provider/wishlist_provider.dart';
import 'package:shopping_app/ui/product_details_screen.dart';
import 'package:shopping_app/ui/widget/star_rating_widget.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/styles.dart';

class ProductListWidget extends StatefulWidget {
  List<ProductModel> productList;
  final Future<void> Function()? onRefresh;

  ProductListWidget({required this.productList, this.onRefresh, Key? key}) : super(key: key);

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  late ProductProviderClass providerClass;

  @override
  void initState() {
    super.initState();
    providerClass = Provider.of<ProductProviderClass>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProductProviderClass, bool>(
      selector: (p0, provider) => provider.isListView,
      builder: (context, _, __) {
        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = (constraints.maxWidth / 160).floor().clamp(2, 6);
              final grid = GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 0.72,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            itemCount: widget.productList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context)
                      .requestFocus(new FocusNode()); //un focus keyboard
                  //navigating to product details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                          productModel: widget.productList[index]),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Stack(
                      children: <Widget>[
                        Image(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.productList[index].imageUrl,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withAlpha(160),
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.productList[index].name,
                                  style: itemNameText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$${widget.productList[index].price.toStringAsFixed(2)}',
                                  style: itemPriceText,
                                ),
                                const SizedBox(height: 2),
                                StarRatingWidget(
                                  rating: widget.productList[index].rating,
                                  count: widget.productList[index].ratingCount,
                                  size: 11,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.productList[index].rating >= 4.5)
                                _Badge(label: '⭐ Top Rated', color: Colors.amber.shade700),
                              if (widget.productList[index].price < 25)
                                _Badge(label: '🏷️ Sale', color: Colors.redAccent),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Consumer<WishlistProvider>(
                            builder: (context, wishlist, _) {
                              final isWishlisted = wishlist.isWishlisted(widget.productList[index]);
                              return GestureDetector(
                                onTap: () {
                                  final isWishlisted = wishlist.isWishlisted(widget.productList[index]);
                                  wishlist.toggle(widget.productList[index]);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(isWishlisted
                                        ? 'Removed from wishlist'
                                        : 'Added to wishlist ❤️'),
                                    duration: const Duration(seconds: 2),
                                  ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                                    color: brandColor,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          if (widget.onRefresh != null) {
            return RefreshIndicator(onRefresh: widget.onRefresh!, child: grid);
          }
          return grid;
        },
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
