import 'dart:io';

import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/custom/custom.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/body.dart';
import 'widgets/refine.dart';
import 'widgets/heading_list.dart';
import 'widgets/filter_list.dart';
import 'widgets/sort.dart';


class ProductListScreen extends StatefulWidget {
  static const routeName = '/product_list';

  const ProductListScreen({Key? key, this.args, this.store}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();

  final Map? args;
  final SettingStore? store;
}

class _ProductListScreenState extends State<ProductListScreen>
    with ShapeMixin, Utility, HeaderListMixin, ProductListMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsStore? _productsStore;
  FilterStore? _filterStore;
  int typeView = 2;

  @override
  void initState() {
    super.initState();
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);

    // Configs
    Data data = widget.store!.data!.screens!['products']!;
    WidgetConfig widgetConfig = data.widgets!['productListPage']!;
    ProductCategory? category = getCategory(widget.args);
    Brand? brand = getBrand(widget.args);
    List<int>? tag = getTag(widget.args);
    String? orderby = widget.args?['orderby'];

    _productsStore = ProductsStore(
      widget.store!.requestHelper,
      category: category,
      brand: brand,
      tag: tag,
      perPage: ConvertData.stringToInt(
          get(widgetConfig.fields, ['itemPerPage'], 10)),
      currency: widget.store!.currency,
      language: widget.store!.locale,
      sort: getSort(orderby),
      locationStore: authStore.locationStore,
    );
    _filterStore = FilterStore(
      widget.store!.requestHelper,
      category: category,
      language: widget.store!.locale,
    );
    init();
  }

  Map getSort(String? orderBy) {
    switch (orderBy) {
      case 'popularity':
        return listSortBy[2];
      case 'rating':
        return listSortBy[3];
      case 'date':
        return listSortBy[4];
      case 'price':
        return listSortBy[5];
      case 'price-desc':
        return listSortBy[6];
      default:
        return listSortBy[1];
    }
  }

  Future<void> init() async {
    await _productsStore!.getProducts();
    await _filterStore!.getAttributes();
    await _filterStore!.getMinMaxPrices();
  }

  // Fetch product data
  Future<List<Product>> _getProducts() async {
    return _productsStore!.getProducts();
  }

  Future _refresh() {
    return _productsStore!.refresh();
  }

  void _clearAll() {
    _filterStore!.onChange(
      inStock: _productsStore!.filter!.inStock,
      onSale: _productsStore!.filter!.onSale,
      featured: _productsStore!.filter!.featured,
      category: _productsStore!.filter!.category,
      attributeSelected: _productsStore!.filter!.attributeSelected,
      productPrices: _productsStore!.filter!.productPrices,
      rangePrices: _productsStore!.filter!.rangePrices,
    );
  }

  void onSubmit(FilterStore? filter) {
    if (filter != null) {
      _productsStore!.onChanged(filterStore: filter);
    } else {
      _clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Configs
    Data data = widget.store!.data!.screens!['products']!;
    WidgetConfig widgetConfig = data.widgets!['productListPage']!;

    String? refinePosition = get(
        widgetConfig.fields, ['refinePosition'], Strings.refinePositionBottom);
    String? refineItemStyle = get(widgetConfig.fields, ['refineItemStyle'],
        Strings.refineItemStyleListTitle);
    int itemPerPage =
        ConvertData.stringToInt(get(widgetConfig.fields, ['itemPerPage'], 10));
    String thumbSizes = get(widgetConfig.fields, ['thumbSizes'], 'src');

    List<Product> loadingProduct =
        List.generate(itemPerPage, (index) => Product()).toList();
    ProductCategory? category = getCategory(widget.args);
    Brand? brand = getBrand(widget.args);

    return Observer(
      builder: (_) {
        bool isShimmer =
            _productsStore!.products.isEmpty && _productsStore!.loading;
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: buildRefine(context,
                category: category,
                min: 1,
                refinePosition: refinePosition,
                refineItemStyle: refineItemStyle),
          ),
          endDrawer: Drawer(
            child: buildRefine(context,
                category: category,
                min: 1,
                refinePosition: refinePosition,
                refineItemStyle: refineItemStyle),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Body(
                        brand: brand,
                        category: category,
                        products: isShimmer
                            ? loadingProduct
                            : _productsStore!.products
                                .where(productCatalog)
                                .toList(),
                        loading: _productsStore!.loading,
                        refresh: _refresh,
                        getProducts: _getProducts,
                        canLoadMore: _productsStore!.canLoadMore,
                        thumbSizes: thumbSizes,
                        heading: HeadingList(
                          height: 58,
                          sort: _productsStore!.sort,
                          onchangeSort: (Map sort) =>
                              _productsStore!.onChanged(sort: sort),
                          clickRefine: () async {
                            if (refinePosition == Strings.refinePositionLeft) {
                              _scaffoldKey.currentState!.openDrawer();
                            } else if (refinePosition ==
                                Strings.refinePositionRight) {
                              _scaffoldKey.currentState!.openEndDrawer();
                            } else {
                              showModalBottomSheet<FilterStore>(
                                isScrollControlled: true,
                                context: context,
                                shape: borderRadiusTop(),
                                builder: (context) => buildRefine(context,
                                    category: category,
                                    refinePosition: refinePosition,
                                    refineItemStyle: refineItemStyle),
                              );
                            }
                          },
                          typeView: typeView,
                          onChangeType: (int visit) => setState(() {
                            typeView = visit;
                          }),
                        ),
                        filter: FilterList(
                          productsStore: _productsStore,
                          filter: _filterStore,
                          category: category,
                        ),
                        heightHeading: 58,
                        configs: data.configs,
                        styles: widgetConfig.styles,
                        typeView: typeView,
                      ),
                    ),
                    CustomPolicyFooter(withWhatsAppIcon: false),
                  ],
                ),
                Column(
                  children: [
                    Expanded(child: Container()),
                    CustomPolicyFooter(withWhatsAppIcon: true),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildRefine(
    BuildContext context, {
    ProductCategory? category,
    double min = 0.8,
    String? refinePosition = Strings.refinePositionBottom,
    String? refineItemStyle = Strings.refineItemStyleListTitle,
  }) {
    return Refine(
      filterStore: _filterStore,
      category: category,
      clearAll: _clearAll,
      onSubmit: onSubmit,
      min: min,
      refineItemStyle: refineItemStyle,
      refinePosition: refinePosition,
    );
  }
}

class CustomPolicyFooter extends StatelessWidget with NavigationMixin {
  CustomPolicyFooter({super.key, required this.withWhatsAppIcon});
  final bool withWhatsAppIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (withWhatsAppIcon)
              const SizedBox(
                height: 30,
              ),
            Container(
              color: ColorBlock.b2Black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        launchUrl(Uri.parse('tel:054-719-9390'));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_enabled_outlined,
                              color: Colors.white),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "054-719-9390",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/custom',
                                    arguments: {
                                      "name": "Privacy policies",
                                      "key": "extraScreens_privacy-policies"
                                    });
                              },
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('privacy_policy'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline))),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, _, __) =>
                                      const CustomScreen(
                                    screenKey: 'extraScreens_shipping-policy',
                                    extraData: {
                                      'title': 'shipping policy',
                                      'icon': 'chevron-left'
                                    },
                                  ),
                                ));
                              },
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('shipping_policy'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline))),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/custom',
                                    arguments: {
                                      "name": "Terms &amp; Conditions",
                                      "key": "extraScreens_terms-conditions"
                                    });
                              },
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('site_regulation'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.shade100,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate('location_address'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Copyright © B2B420',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // add WhatsApp icon
        if (withWhatsAppIcon)
          Positioned(
            top: 0,
            right: 30,
            child: GestureDetector(
              onTap: () {
                whatsapp();
              },
              child: Image.asset(
                "assets/images/whatsappicon.png",
                height: 60,
              ),
            ),
          ),
      ],
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(
    Uri.parse(url),
  )) {
    throw Exception('Could not launch $url');
  }
}

whatsapp() async {
  var contact = "+972547199390";
  var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
  var iosUrl =
      "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    // EasyLoading.showError('WhatsApp is not installed.');
  }
}
