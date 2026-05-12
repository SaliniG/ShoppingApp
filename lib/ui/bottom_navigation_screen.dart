import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/resource/provider/cart_provider.dart';
import 'package:shopping_app/resource/provider/screen_index_provider.dart';
import 'package:shopping_app/resource/provider/wishlist_provider.dart';
import 'package:shopping_app/ui/cart_screen.dart';
import 'package:shopping_app/ui/home_screen.dart';
import 'package:shopping_app/ui/order_history_screen.dart';
import 'package:shopping_app/ui/wishlist_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  List<dynamic> screens = [
    const HomeScreen(),
    const CartScreen(),
    const WishlistScreen(),
    const OrderHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenIndexProvider = Provider.of<ScreenIndexProvider>(context);
    int currentScreenIndex = screenIndexProvider.fetchCurrentScreenIndex;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        currentIndex: currentScreenIndex,
        onTap: (value) => screenIndexProvider.updateScreenIndex(value),
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(currentScreenIndex == 0 ? Icons.home : Icons.home_outlined),
            backgroundColor: Colors.indigo,
          ),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                final itemCount = Cart().itemsMap.values.fold(0, (sum, qty) => sum + qty);
                return Badge(
                  isLabelVisible: itemCount > 0,
                  label: Text('$itemCount', style: const TextStyle(fontSize: 10)),
                  child: Icon(currentScreenIndex == 1
                      ? Icons.shopping_cart
                      : Icons.add_shopping_cart),
                );
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Wishlist',
            icon: Consumer<WishlistProvider>(
              builder: (context, wishlist, _) {
                final count = wishlist.items.length;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count', style: const TextStyle(fontSize: 10)),
                  child: Icon(currentScreenIndex == 2
                      ? Icons.favorite
                      : Icons.favorite_border),
                );
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Orders',
            icon: Icon(currentScreenIndex == 3
                ? Icons.receipt_long
                : Icons.receipt_long_outlined),
          ),
        ],
      ),
      body: screens[currentScreenIndex],
    );
  }
}
