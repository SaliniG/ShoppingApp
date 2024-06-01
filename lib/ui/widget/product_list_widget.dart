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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        child: ClipRRect(
                          child: Image(
                            height: height * 0.14,
                            width: width * 0.16,
                            image: NetworkImage(
                              widget.productList[index].imageUrl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              widget.productList[index].name,
                              style: titleTextStyle,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              widget.productList[index].price.toString(),
                              style: autoCompleteTextStyle,
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
        );
      },
    );
  }
}
