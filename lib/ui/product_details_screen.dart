import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/provider/cart_provider.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/utils/styles.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatefulWidget {
  static const routerPath = '/articlesDetailsScreen';
  ProductModel productModel;

  ProductDetailsScreen({required this.productModel, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late CartProvider cartProvider;

  @override
  void initState() {
    super.initState();
    //initialize cart provider class
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.productCount = Cart().itemsMap[widget.productModel] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          textAlign: TextAlign.center,
          'Product Details',
          style: headlineTextStyleSemiBold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Image(
                  image: NetworkImage(widget.productModel.imageUrl),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.productModel.name,
                        style: headlineTextStyleSemiBold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.productModel.description,
                        style: autoCompleteTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${AppConstants.dollarText}${widget.productModel.price}",
                        style: headlineTextStyle,
                      ),
                    ],
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (context, value, child) => Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, left: 10.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Cart cart =  Cart();
                            ProductModel product = widget.productModel;
                            int currentValue = cart.itemsMap[product] ?? 0;
                            int newValue = currentValue + 1;
                            cart.itemsMap[product] = newValue;

                            value.incrementCounter(newValue);
                            value.addPrice(widget.productModel.price);
                          },
                          child: Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: brandColor),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add_shopping_cart,
                                        color: kTextColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "${value.productCount} items added to Cart",
                            style: headlineTextStyleSemiBold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
