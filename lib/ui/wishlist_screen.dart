import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No favourites yet', style: headlineTextStyle),
                  ],
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
