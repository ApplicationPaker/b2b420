import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/product_category/product_category_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/body_horizontal.dart';
import 'widgets/body_vertical.dart';
import 'widgets/body_default.dart';

class ProductCategoryScreen extends StatefulWidget {
  static const routeName = '/product_category';

  const ProductCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen>
    with LoadingMixin, Utility, CategoryMixin {
  late ProductCategoryStore _productCategoryStore;
  SettingStore? _settingStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productCategoryStore = Provider.of<ProductCategoryStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
  }

  List<ProductCategory> excludeData(
      List<ProductCategory> categories, List exclude) {
    if (exclude.isEmpty) {
      return categories;
    }
    return categories
        .where((category) => exclude
            .where((element) =>
                ConvertData.stringToInt(element['key']) == category.id)
            .toList()
            .isEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final String languageKey = _settingStore?.languageKey ?? 'text';
        final String themeModeKey = _settingStore?.themeModeKey ?? 'value';

        final WidgetConfig widgetConfig = _settingStore!
            .data!.screens!['category']!.widgets!['categoryPage']!;
        final Map<String, dynamic>? configs =
            _settingStore!.data!.screens!['category']!.configs;

        String layout = widgetConfig.layout ?? 'vertical';

        final Data? data = _settingStore?.data?.screens?['home'];
        List<ProductCategory> categories = [];
        if (data != null) {
          Map<String, dynamic> fields =
              data.widgets?['product-category_1618802700325_0u7cfb']?.fields ??
                  {};
          int limit = ConvertData.stringToInt(get(fields, ['limit'], 4));
          List<int>? excludeCategory = get(fields, ['excludeCategory'], [])
              .map((e) => ConvertData.stringToInt(e['key']))
              .toList()
              .cast<int>();

          List<int>? includeCategory = get(fields, ['includeCategory'], [])
              .map((e) => ConvertData.stringToInt(e['key']))
              .toList()
              .cast<int>();
          bool? showHierarchy = get(fields, ['showHierarchy'], true);
          Map<String, dynamic>? template = get(fields, ['template'], {});
          List<ProductCategory?> categoriesList = exclude(
            categories: include(
              categories: showHierarchy!
                  ? _productCategoryStore.categories
                  : flatten(categories: _productCategoryStore.categories),
              includes: includeCategory!,
            ),
            excludes: excludeCategory!,
          )!;
          for (final category in categoriesList) {
            if (category != null) {
              categories.add(category);
            }
          }
        }

        if (_productCategoryStore.loading) {
          return buildLoading(context, isLoading: true);
        }
        EdgeInsetsDirectional padding = ConvertData.space(
            get(widgetConfig.styles, ['padding'], {}), 'padding');
        EdgeInsetsDirectional margin = ConvertData.space(
            get(widgetConfig.styles, ['margin'], {}), 'margin');
        // Layout
        // String layout = widget?.widgetConfig?.layout ?? Strings.productCategoryLayoutList;

        // Styles

        Widget child;
        switch (layout) {
          case 'horizontal':
            child = HorizontalCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
            );
            break;
          case 'vertical':
            child = VerticalCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
            );
            break;
          default:
            child = Padding(
              padding: const EdgeInsets.only(bottom: 99),
              child: DefaultCategory(
                categories: categories,
                configs: configs,
                widgetConfig: widgetConfig,
                languageKey: languageKey,
                themeModeKey: themeModeKey,
              ),
            );
        }
        return Container(
          padding: padding,
          margin: margin,
          child: child,
        );
      },
    );
  }
}
