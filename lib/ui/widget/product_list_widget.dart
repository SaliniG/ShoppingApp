import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/modal/ui/product_modal.dart';
import 'package:shopping_app/resource/provider/product_provider.dart';
import 'package:shopping_app/ui/product_details_screen.dart';
import 'package:shopping_app/utils/styles.dart';

class ProductListWidget extends StatefulWidget {
  List<ProductModel> productList;

  ProductListWidget({required this.productList, Key? key}) : super(key: key);

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  late ProductProviderClass providerClass;

  @override
  void initState() {
    super.initState();
    providerClass = Provider.of<ProductProviderClass>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProductProviderClass, bool>(
      selector: (p0, provider) => provider.isListView,
      builder: (context, _, __) {
        return Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 3
                        : 2),
            itemCount: widget.productList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context)
                      .requestFocus(new FocusNode()); //un focus keyboard
                  //navigating to product details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                          productModel: widget.productList[index]),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Stack(
                      children: <Widget>[
                        Image(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.productList[index].imageUrl,
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            child: Container(
                              width: double.infinity,
                              color: Colors.black.withAlpha(100),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.productList[index].name,
                                      style: itemNameText,
                                    ),
                                    Text(
                                      '\$${widget.productList[index].price.toStringAsFixed(2)}',
                                      style: itemPriceText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
