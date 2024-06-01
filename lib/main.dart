import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/cart_provider.dart';
import 'package:shopping_app/resource/provider/product_provider.dart';
import 'package:shopping_app/resource/provider/screen_index_provider.dart';
import 'package:shopping_app/ui/bottom_navigation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScreenIndexProvider()),
        ChangeNotifierProvider(create: (context) => ProductProviderClass()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        home: BottomNavigationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
