import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/screen_index_provider.dart';
import 'package:shopping_app/ui/cart_screen.dart';
import 'package:shopping_app/ui/home_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  List<dynamic> screens = [
    const HomeScreen(),
    const CartScreen(),
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
              backgroundColor: Colors
                  .indigo // provide color to any one icon as it will overwrite the whole bottombar's color ( if provided any )
              ),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Icon((currentScreenIndex == 1)
                ? Icons.shopping_cart
                : Icons.add_shopping_cart),
          ),
        ],
      ),
      body: screens[currentScreenIndex],
    );
  }
}
