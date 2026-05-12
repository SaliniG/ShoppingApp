import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/product_provider.dart';
import 'package:shopping_app/ui/widget/product_list_widget.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App', style: headlineTextStyleSemiBold),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
                        provider.clearSearch();
                        FocusScope.of(context).requestFocus(FocusNode());
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
                  const SizedBox(height: 8),
                  // Category filter chips
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CategoryChip(
                          label: 'All',
                          selected: provider.selectedCategory == null,
                          onTap: () => provider.setCategory(null),
                        ),
                        ...provider.categories.map(
                          (cat) => _CategoryChip(
                            label: _formatCategory(cat),
                            selected: provider.selectedCategory == cat,
                            onTap: () => provider.setCategory(cat),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProductListWidget(productList: provider.productsList),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCategory(String cat) {
    return cat.split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? brandColor : Colors.transparent,
            border: Border.all(color: brandColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : brandColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
