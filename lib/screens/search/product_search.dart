import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/types/types.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'widget/product/result_product.dart';
import 'widget/product/search_product.dart';

class ProductSearchDelegate extends SearchDelegate<String?> {
  ProductSearchDelegate(BuildContext context, TranslateType translate)
      : super(searchFieldLabel: translate('product_category_search'));

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: const TextTheme(
        // Use this to change the query's text style
        titleLarge: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorBlock.b2Black,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,

        // Use this change the placeholder's text style
        hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey),
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(FeatherIcons.arrowLeft, size: 22),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Search(
      search: query,
      onChange: (String? title) {
        query = title ?? '';
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Result(
      search: query,
      clearText: () {
        query = '';
        showSuggestions(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        IconButton(
          tooltip: 'Close',
          icon: const Icon(FeatherIcons.x, size: 22),
          onPressed: () => Navigator.pop(context),
        )
      else
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(FeatherIcons.x, size: 22),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

}
