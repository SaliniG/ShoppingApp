import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/product_provider.dart';
import 'package:shopping_app/resource/provider/search_history_provider.dart';
import 'package:shopping_app/resource/provider/theme_provider.dart';
import 'package:shopping_app/ui/widget/product_list_widget.dart';
import 'package:shopping_app/ui/widget/product_skeleton_widget.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showHistory = _focusNode.hasFocus && _searchController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _applySearch(String query, ProductProviderClass provider) {
    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(offset: query.length);
    provider.setResults(provider.productsList, query);
    setState(() => _showHistory = false);
    _focusNode.unfocus();
  }

  void _onSearchChanged(String value, ProductProviderClass provider) {
    if (value.isEmpty) {
      provider.clearSearch();
      setState(() => _showHistory = _focusNode.hasFocus);
    } else {
      provider.setResults(provider.productsList, value);
      setState(() => _showHistory = false);
    }
  }

  void _onSearchSubmitted(String value, ProductProviderClass provider) {
    if (value.trim().isEmpty) return;
    Provider.of<SearchHistoryProvider>(context, listen: false).add(value.trim());
    provider.setResults(provider.productsList, value);
    setState(() => _showHistory = false);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App', style: headlineTextStyleSemiBold),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, theme, _) => IconButton(
              icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: theme.isDark ? 'Light mode' : 'Dark mode',
              onPressed: theme.toggle,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ChangeNotifierProvider<ProductProviderClass>(
            create: (context) => ProductProviderClass()..fetchProductDetails(),
            child: Consumer<ProductProviderClass>(
              builder: (context, provider, child) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          maxLines: null,
                          onChanged: (v) => _onSearchChanged(v, provider),
                          onSubmitted: (v) => _onSearchSubmitted(v, provider),
                          textInputAction: TextInputAction.search,
                          style: autoCompleteTextStyle,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search',
                            hintStyle: searchHintTextStyle,
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.clearSearch();
                                      setState(() => _showHistory = _focusNode.hasFocus);
                                    },
                                  )
                                : const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<SortOption>(
                        icon: Icon(
                          Icons.sort,
                          color: provider.sortOption != SortOption.none ? brandColor : null,
                        ),
                        tooltip: 'Sort',
                        onSelected: provider.setSort,
                        itemBuilder: (_) => [
                          _sortItem(SortOption.none, 'Default', provider.sortOption),
                          _sortItem(SortOption.priceLow, 'Price: Low to High', provider.sortOption),
                          _sortItem(SortOption.priceHigh, 'Price: High to Low', provider.sortOption),
                          _sortItem(SortOption.ratingHigh, 'Top Rated', provider.sortOption),
                        ],
                      ),
                    ],
                  ),
                  // Recent search history
                  if (_showHistory)
                    Consumer<SearchHistoryProvider>(
                      builder: (context, historyProvider, _) {
                        final history = historyProvider.history;
                        if (history.isEmpty) return const SizedBox.shrink();
                        return Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 8, 4, 4),
                                child: Row(
                                  children: [
                                    const Text('Recent', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: historyProvider.clear,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text('Clear all', style: TextStyle(fontSize: 12, color: brandColor)),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                              ...history.map((q) => InkWell(
                                    onTap: () => _applySearch(q, provider),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.history, size: 16, color: Colors.grey),
                                          const SizedBox(width: 10),
                                          Expanded(child: Text(q, style: autoCompleteTextStyle)),
                                          IconButton(
                                            icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () => historyProvider.remove(q),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 4),
                            ],
                          ),
                        );
                      },
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
                  if (provider.isLoading)
                    const ProductSkeletonWidget()
                  else
                    ProductListWidget(
                      productList: provider.productsList,
                      onRefresh: () async => provider.fetchProductDetails(),
                    ),
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

  PopupMenuItem<SortOption> _sortItem(SortOption value, String label, SortOption current) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          if (current == value)
            const Icon(Icons.check, size: 16, color: brandColor)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
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
