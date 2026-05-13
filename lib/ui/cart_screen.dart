import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/provider/cart_provider.dart';
import 'package:shopping_app/resource/provider/screen_index_provider.dart';
import 'package:shopping_app/ui/payment_screen.dart';
import 'package:shopping_app/utils/assets_path.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/utils/styles.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

const Map<String, int> _validCoupons = {
  'SAVE10': 10,
  'SAVE20': 20,
  'HALF50': 50,
  'WELCOME': 15,
};

class _CartScreenState extends State<CartScreen> {
  List<ProductModel> cartList = [];
  late CartProvider cartProvider;
  final _couponController = TextEditingController();
  String? _appliedCoupon;
  int _discountPercent = 0;

  @override
  void initState() {
    Cart cart = Cart();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    cart.itemsMap.forEach((k, v) => cartList.add(k));
    super.initState();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (_validCoupons.containsKey(code)) {
      setState(() {
        _appliedCoupon = code;
        _discountPercent = _validCoupons[code]!;
      });
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code'), duration: Duration(seconds: 2)),
      );
    }
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _discountPercent = 0;
      _couponController.clear();
    });
  }

  double _discountedTotal(double total) =>
      total * (1 - _discountPercent / 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: headlineTextStyleSemiBold),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: cartList.isEmpty ? _buildEmptyState() : _buildCartBody(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(cartEmptyImagePath, width: 160, height: 160),
            const SizedBox(height: 20),
            const Text('Your cart is empty', style: headlineTextStyleSemiBold),
            const SizedBox(height: 8),
            const Text(
              'Looks like you haven\'t added anything yet.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Provider.of<ScreenIndexProvider>(context, listen: false)
                    .updateScreenIndex(0);
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Start Shopping'),
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

  Widget _buildCartBody() {
    return Consumer<CartProvider>(
      builder: (context, value, child) => Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: cartList.length,
              itemBuilder: (BuildContext context, int index) {
                final product = cartList[index];
                final qty = Cart().itemsMap[product] ?? 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: titleTextStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Selector<CartProvider, bool>(
                                selector: (_, p) => p.isUpdateCount,
                                builder: (_, __, ___) => Text(
                                  '\$${(product.price * (Cart().itemsMap[product] ?? 0)).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Selector<CartProvider, bool>(
                          selector: (_, p) => p.isUpdateCount,
                          builder: (_, __, ___) => Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  final currentValue = Cart().itemsMap[product] ?? 0;
                                  final newValue = currentValue - 1;
                                  if (newValue <= 0) {
                                    Cart().itemsMap.remove(product);
                                  } else {
                                    Cart().itemsMap[product] = newValue;
                                  }
                                  value.decrementCounter(newValue);
                                  value.subtractPrice(product.price);
                                },
                                child: const Icon(Icons.remove_circle, size: 32, color: brandColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text('$qty', style: headlineTextStyleSemiBold),
                              ),
                              InkWell(
                                onTap: () {
                                  final currentValue = Cart().itemsMap[product] ?? 0;
                                  Cart().itemsMap[product] = currentValue + 1;
                                  value.incrementCounter(currentValue + 1);
                                  value.addPrice(product.price);
                                },
                                child: const Icon(Icons.add_circle, size: 32, color: brandColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Coupon field
                if (_appliedCoupon == null)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'Coupon code',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _applyCoupon,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Apply', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.local_offer, color: brandColor, size: 18),
                      const SizedBox(width: 6),
                      Text('$_appliedCoupon — $_discountPercent% off',
                          style: const TextStyle(color: brandColor, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: _removeCoupon,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                // Total rows
                if (_appliedCoupon != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: titleTextStyle),
                      Text('${AppConstants.dollarText}${value.totalPrice.toStringAsFixed(2)}',
                          style: titleTextStyle),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount ($_discountPercent%)',
                          style: const TextStyle(color: Colors.green, fontSize: 13)),
                      Text(
                        '- ${AppConstants.dollarText}${(value.totalPrice - _discountedTotal(value.totalPrice)).toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green, fontSize: 13),
                      ),
                    ],
                  ),
                  const Divider(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: titleTextStyle),
                    Text(
                      '${AppConstants.dollarText}${_discountedTotal(value.totalPrice).toStringAsFixed(2)}',
                      style: headlineTextStyleBold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(totalPrice: _discountedTotal(value.totalPrice)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandColor,
                    minimumSize: const Size(200, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(color: kTextColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
