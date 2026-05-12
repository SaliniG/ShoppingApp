import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/screen_index_provider.dart';
import 'package:shopping_app/ui/cart_screen.dart';
import 'package:shopping_app/ui/home_screen.dart';
import 'package:shopping_app/ui/wishlist_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  List<dynamic> screens = [
    const HomeScreen(),
    const CartScreen(),
    const WishlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final _screenIndexProvider = Provider.of<ScreenIndexProvider>(context);
    int currentScreenIndex = _screenIndexProvider.fetchCurrentScreenIndex;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        currentIndex: currentScreenIndex,
        onTap: (value) => _screenIndexProvider.updateScreenIndex(value),
        items: [
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                  (currentScreenIndex == 0) ? Icons.home : Icons.home_outlined),
              backgroundColor: Colors.indigo),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Icon((currentScreenIndex == 1)
                ? Icons.shopping_cart
                : Icons.add_shopping_cart),
          ),
          BottomNavigationBarItem(
            label: 'Wishlist',
            icon: Icon((currentScreenIndex == 2)
                ? Icons.favorite
                : Icons.favorite_border),
          ),
        ],
      ),
      body: screens[currentScreenIndex],
    );
  }
}
