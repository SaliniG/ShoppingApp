import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/product_provider.dart';
import 'package:shopping_app/ui/widget/product_list_widget.dart';
import 'package:shopping_app/utils/styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ChangeNotifierProvider<ProductProviderClass>(
            create: (context) => ProductProviderClass()..fetchProductDetails(),
            child: Consumer<ProductProviderClass>(
              builder: (context, provider, child) => Column(
                children: [
                  TextField(
                    maxLines: null,
                    onChanged: (search) {
                      if (search.isEmpty) {
                        provider.fetchProductDetails();
                        FocusScope.of(context).requestFocus(new FocusNode());
                      } else {
                        provider.setResults(provider.productsList, search);
                      }
                    },
                    textInputAction: TextInputAction.go,
                    style: autoCompleteTextStyle,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search',
                      hintStyle: searchHintTextStyle,
                      suffixIcon: const IconButton(
                        icon: Icon(Icons.search),
                        onPressed: null,
                        splashRadius: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Selector<ProductProviderClass, bool>(
                    selector: (p0, provider) => provider.isSearch,
                    builder: (context, _, __) {
                      //return product list widget
                      return ProductListWidget(
                          productList: provider.productsList);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
