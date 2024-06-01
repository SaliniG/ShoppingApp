import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/screen_index_provider.dart';
import 'package:shopping_app/ui/bottom_navigation_screen.dart';
import 'package:shopping_app/utils/assets_path.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/utils/styles.dart';

class PlaceOrderScreen extends StatelessWidget {
  final double totalPrice;

  const PlaceOrderScreen({required this.totalPrice, super.key});

  @override
  Widget build(BuildContext context) {
    final _screenIndexProvider = Provider.of<ScreenIndexProvider>(context);
    _screenIndexProvider.updateScreenIndex(0);

    return Scaffold(
      backgroundColor: kTextColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Total Payment amount.",
            style: headlineTextStyle,
          ),
          Text(
            "${AppConstants.dollarText}${totalPrice.toStringAsFixed(2)}",
            style: headlineTextStyleBold,
          ),
          const Image(
            image: AssetImage(greenTickImagePath),
          ),
          const Text(
            "Order is successfully placed.",
            style: headlineTextStyle,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => BottomNavigationScreen()),
                  (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: brandColor),
                child: const Center(
                  child: Text(
                    "GO BACK. ENJOY SHOPPING!",
                    style: headingTextConfirmation,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
