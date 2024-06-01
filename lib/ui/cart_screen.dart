import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/provider/cart_provider.dart';
import 'package:shopping_app/ui/place_order_screen.dart';
import 'package:shopping_app/utils/assets_path.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/utils/styles.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProductModel> cartList = [];

  late CartProvider cartProvider;

  @override
  void initState() {
    //initialize singleton cart class
    Cart cart = Cart();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    //getting items from cart and added to cart list
    cart.itemsMap.forEach((k, v) => cartList.add(k));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cartList.isEmpty
          ? const Center(
              child: Image(
                image: AssetImage(cartEmptyImagePath),
              ),
            )
          : Consumer<CartProvider>(
              builder: (context, value, child) => Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: ClipRect(
                                        child: Image(
                                          image: NetworkImage(
                                            cartList[index].imageUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(cartList[index].name),
                                    Selector<CartProvider, bool>(
                                        selector: (p0, provider) =>
                                            provider.isUpdateCount,
                                        builder: (context, _, __) {
                                          return Text(
                                            (cartList[index].price *
                                                    (Cart().itemsMap[
                                                            cartList[index]] ??
                                                        0))
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 15),
                                          );
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  child:
                                      // to set the quantity
                                      Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          //function call to decrement the item quantity
                                          Cart cart = Cart();
                                          ProductModel product =
                                              cartList[index];
                                          int currentValue =
                                              cart.itemsMap[product] ?? 0;
                                          int newValue = currentValue - 1;
                                          if (newValue <= 0) {
                                            cart.itemsMap.remove(product);
                                          } else {
                                            cart.itemsMap[product] = newValue;
                                          }

                                          value.decrementCounter(newValue);
                                          //function call to decrement the total price from the current price
                                          value.subtractPrice(
                                              cartList[index].price);
                                        },
                                        child: Selector<CartProvider, bool>(
                                          selector: (p0, provider) =>
                                              provider.isUpdateCount,
                                          builder: (context, _, __) {
                                            return const Icon(
                                              Icons.remove_circle,
                                              size: 40,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${Cart().itemsMap[cartList[index]] ?? 0}",
                                        style: headlineTextStyleSemiBold,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Cart cart = Cart();
                                            //function call to increment the item quantity
                                            ProductModel product =
                                                cartList[index];
                                            int currentValue =
                                                cart.itemsMap[product] ?? 0;
                                            int newValue = currentValue + 1;
                                            cart.itemsMap[product] = newValue;

                                            value.incrementCounter(newValue);
                                            //function call to added the total price from the current price
                                            value.addPrice(
                                                cartList[index].price);
                                          },
                                          child: Selector<CartProvider, bool>(
                                              selector: (p0, provider) =>
                                                  provider.isUpdateCount,
                                              builder: (context, _, __) {
                                                return const Icon(
                                                  Icons.add_circle,
                                                  size: 40,
                                                );
                                              })),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Total", style: headlineTextStyle),
                      Text(
                        "${AppConstants.dollarText}${(value.totalPrice).toStringAsFixed(2)}",
                        style: headlineTextStyleBold,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlaceOrderScreen(totalPrice: value.totalPrice),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          // fromHeight use double.infinity as width and 40 is the height
                          minimumSize: const Size.fromHeight(40),
                          padding: const EdgeInsets.all(10),
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: const Text(
                        'PROCEED TO CHECKOUT',
                        style: TextStyle(color: kTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
