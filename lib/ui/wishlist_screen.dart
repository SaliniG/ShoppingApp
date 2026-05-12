import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/screen_index_provider.dart';
import 'package:shopping_app/resource/provider/wishlist_provider.dart';
import 'package:shopping_app/ui/product_details_screen.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/styles.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist', style: headlineTextStyleSemiBold),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Consumer<WishlistProvider>(
          builder: (context, provider, _) {
            final items = provider.items;
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: brandColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_border, size: 60, color: brandColor),
                      ),
                      const SizedBox(height: 20),
                      const Text('No favourites yet', style: headlineTextStyleSemiBold),
                      const SizedBox(height: 8),
                      const Text(
                        'Save items you love by tapping the heart icon.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<ScreenIndexProvider>(context, listen: false)
                              .updateScreenIndex(0);
                        },
                        icon: const Icon(Icons.explore_outlined),
                        label: const Text('Explore Products'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.network(product.imageUrl, fit: BoxFit.contain),
                    ),
                    title: Text(product.name, style: titleTextStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: brandColor),
                      onPressed: () => provider.toggle(product),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(productModel: product),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
