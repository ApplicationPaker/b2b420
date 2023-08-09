import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/product_brand.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/screens/auth/login_screen.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/utils/url_launcher.dart';

import 'product_grid_new.dart';
import 'product_horizontal_item_new.dart';
import 'product_related_new.dart';

class CirillaProductItem extends StatefulWidget {
  final Product? product;

  // Product item template
  final String? template;

  final double width;

  final double height;

  final Map<String, dynamic>? dataTemplate;

  final Color? background;
  final Color? textColor;
  final Color? subTextColor;
  final Color? priceColor;
  final Color? salePriceColor;
  final Color? regularPriceColor;
  final Color? wishlistColor;

  final Color? labelNewColor;
  final Color? labelNewTextColor;
  final double? labelNewRadius;

  final Color? labelSaleColor;
  final Color? labelSaleTextColor;
  final double? labelSaleRadius;

  final IconData? iconAddCart;
  final double? radiusAddCart;
  final bool? outlineAddCart;

  /// use card vertical or card horizontal
  final bool? enableIconCart;

  final double? radius;
  final double? radiusImage;

  final List<BoxShadow>? boxShadow;

  final Border? border;
  final EdgeInsetsGeometry? padding;

  const CirillaProductItem({
    Key? key,
    this.product,
    this.template = Strings.productItemContained,
    this.width = 160,
    this.height = 190,
    this.dataTemplate = const {},
    this.background,
    this.textColor,
    this.subTextColor,
    this.priceColor,
    this.salePriceColor,
    this.regularPriceColor,
    this.wishlistColor,
    this.labelNewColor,
    this.labelNewTextColor,
    this.labelNewRadius = 10,
    this.labelSaleColor,
    this.labelSaleTextColor,
    this.labelSaleRadius = 10,
    this.radius,
    this.radiusImage,
    this.boxShadow,
    this.border,
    this.iconAddCart,
    this.outlineAddCart,
    this.radiusAddCart,
    this.enableIconCart,
    this.padding,
  }) : super(key: key);

  @override
  State<CirillaProductItem> createState() => _CirillaProductItemState();
}

class _CirillaProductItemState extends State<CirillaProductItem>
    with
        CartMixin,
        SnackMixin,
        ProductMixin,
        Utility,
        WishListMixin,
        LoadingMixin,
        ShapeMixin,
        GeneralMixin,
        NavigationMixin {
  int _quantity = 1;
  bool _loading = false;
  late SettingStore _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  ///
  /// Handle add to cart
  Future<void> _handleAddToCart(BuildContext context) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (widget.product == null || widget.product!.id == null) return;

    if (widget.product!.type == productTypeExternal) {
      await launch(widget.product!.externalUrl!);
      return;
    }

    final WidgetConfig? widgetConfig = _settingStore.data != null
        ? _settingStore.data!.settings!['general']!.widgets!['general']
        : null;
    final Map<String, dynamic>? fields =
        widgetConfig != null ? widgetConfig.fields : {};

    bool requiredLogin =
        get(fields, ['forceLoginAddToCart'], false) && !_authStore.isLogin;
    bool enableProductQuickView =
        get(fields, ['enableProductQuickView'], false);

    if (requiredLogin) {
      Navigator.of(context).pushNamed(
        LoginScreen.routeName,
        arguments: {
          'showMessage': ({String? message}) {
            avoidPrint('Login Success');
          },
        },
      );
      return;
    }

    if (enableProductQuickView) {
      showQuickView(
        context: context,
        product: widget.product!,
        settingStore: _settingStore,
      );
      return;
    }

    if (widget.product!.type == productTypeVariable ||
        widget.product!.type == productTypeGrouped ||
        widget.product!.type == productTypeAppointment) {
      _navigate(context);
      return;
    }

    setState(() {
      _loading = true;
    });
    try {
      await addToCart(productId: widget.product!.id, qty: _quantity);
      if (mounted) {
        showSuccess(
          context,
          translate('product_add_to_cart_success'),
          action: SnackBarAction(
            label: translate('product_view_cart'),
            textColor: Colors.white,
            onPressed: () {
              navigate(context, {
                'type': 'tab',
                'route': '/',
                'args': {'key': 'screens_cart'}
              });
            },
          ),
        );
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  ///
  /// Handle navigate
  void _navigate(BuildContext context) {
    showQuickView(
      context: context,
      product: widget.product!,
      settingStore: _settingStore,
    );
  }

  void _navigatePopup(BuildContext context) {
    showQuickView(
      context: context,
      product: widget.product!,
      settingStore: _settingStore,
    );
    return;
  }

  ///
  /// Handle wishlist
  void _wishlist(BuildContext context) {
    if (widget.product == null || widget.product!.id == null) return;
    addWishList(productId: widget.product!.id);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String themeModeKey = _settingStore.themeModeKey;

    final WidgetConfig? widgetConfig = _settingStore.data != null
        ? _settingStore.data!.settings!['general']!.widgets!['general']
        : null;
    final Map<String, dynamic>? fields =
        widgetConfig != null ? widgetConfig.fields : {};

    bool productItemLabelEnableRating =
        get(fields, ['productItemLabelEnableRating'], true);
    bool productItemLabelEnableSale =
        get(fields, ['productItemLabelEnableSale'], true);
    bool productItemLabelEnableNew =
        get(fields, ['productItemLabelEnableNew'], true);
    bool productItemEnableQuantity =
        get(fields, ['productItemEnableQuantity'], false);
    bool productItemEnableAddCart =
        get(fields, ['productItemEnableAddCart'], true);

    bool? enableLabelNew =
        get(widget.dataTemplate, ['enableLabelNew'], productItemLabelEnableNew);
    bool? enableLabelSale = get(
        widget.dataTemplate, ['enableLabelSale'], productItemLabelEnableSale);
    bool? enableCategory = get(widget.dataTemplate, ['enableCategory'], true);
    bool? enableRating = get(
        widget.dataTemplate, ['enableRating'], productItemLabelEnableRating);
    bool enableQuantity =
        get(widget.dataTemplate, ['enableQuantity'], productItemEnableQuantity);
    bool enableAddCart =
        get(widget.dataTemplate, ['enableAddCart'], productItemEnableAddCart);
    String thumbSizes = get(widget.dataTemplate, ['thumbSizes'], 'src');
    BoxFit fit =
        ConvertData.toBoxFit(get(widget.dataTemplate, ['imageSize'], 'cover'));

    TextStyle stylePrice =
        theme.textTheme.titleSmall!.copyWith(color: widget.priceColor);
    TextStyle styleSale = theme.textTheme.titleSmall!
        .copyWith(color: widget.salePriceColor ?? ColorBlock.red);
    TextStyle styleRegular = theme.textTheme.titleSmall!.copyWith(
        color: widget.regularPriceColor, fontWeight: FontWeight.normal);
    TextStyle styleTextFrom =
        theme.textTheme.bodySmall!.copyWith(color: widget.subTextColor);

    print("${widget.template} (widget.template)");
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        switch (widget.template) {
          case Strings.productItemHorizontal:
            double widthImage = 86;
            double heightImage = (widthImage * widget.height) / widget.width;
            double widthView = widget.width;
            return SizedBox(
              width: widthView,
              child: ProductHorizontalItem(
                image: buildImage(
                  context,
                  product: widget.product!,
                  width: widthImage,
                  height: heightImage,
                  borderRadius: widget.radiusImage,
                  fit: fit,
                  thumbSizes: thumbSizes,
                ),
                name: buildName(
                  context,
                  product: widget.product!,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: widget.textColor),
                ),
                price: buildPrice(
                  context,
                  product: widget.product!,
                  priceStyle: stylePrice,
                  saleStyle: styleSale,
                  regularStyle: styleRegular,
                  styleFrom: styleTextFrom,
                ),
                tagExtra: enableLabelNew! || enableLabelSale!
                    ? buildTagExtra(
                        context,
                        product: widget.product!,
                        enableNew: enableLabelNew,
                        newColor: widget.labelNewColor,
                        newTextColor: widget.labelNewTextColor,
                        newRadius: widget.labelNewRadius,
                        enableSale: enableLabelSale,
                        saleColor: widget.labelSaleColor,
                        saleTextColor: widget.labelSaleTextColor,
                        saleRadius: widget.labelSaleRadius,
                      )
                    : null,
                addCart: enableAddCart
                    ? _loading
                        ? _buildLoading(context)
                        : buildAddCart(
                            context,
                            product: widget.product!,
                            onTap: () => _handleAddToCart(context),
                            icon: widget.iconAddCart ?? FeatherIcons.plus,
                            radius: widget.radiusAddCart ?? 8,
                            isButtonOutline: widget.outlineAddCart ?? false,
                          )
                    : null,
                rating: enableRating!
                    ? buildRating(context,
                        product: widget.product!, color: widget.subTextColor)
                    : null,
                quantity: enableQuantity
                    ? buildQuantityItem(
                        context,
                        product: widget.product!,
                        quantity: _quantity,
                        onChanged: (int value) => setState(() {
                          _quantity = value;
                        }),
                      )
                    : null,
                borderRadius: BorderRadius.circular(widget.radius ?? 0),
                border: widget.border,
                boxShadow: widget.boxShadow,
                color: widget.background ?? Colors.transparent,
                onClick: () => _navigate(context),
                padding: widget.padding ?? EdgeInsets.zero,
              ),
            );
          case Strings.productItemEmerge:
            return ProductEmergeItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
                thumbSizes: thumbSizes,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCart: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : buildAddCart(
                          context,
                          product: widget.product!,
                          onTap: () => _handleAddToCart(context),
                          icon: widget.iconAddCart ?? FeatherIcons.plus,
                          radius: widget.radiusAddCart ?? 34,
                          isButtonOutline: widget.outlineAddCart ?? false,
                        )
                  : null,
              rating: enableRating!
                  ? buildRating(context,
                      product: widget.product!, color: widget.subTextColor)
                  : null,
              category: enableCategory!
                  ? buildCategory(context,
                      product: widget.product!, color: widget.subTextColor)
                  : Container(),
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                isSelected: existWishList(productId: widget.product!.id),
                color: widget.wishlistColor,
                onTap: () => _wishlist(context),
              ),
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemVertical:
            return ProductVerticalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
                thumbSizes: thumbSizes,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCart: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : buildAddCart(
                          context,
                          product: widget.product!,
                          icon: widget.iconAddCart ?? FeatherIcons.plus,
                          radius: widget.radiusAddCart ?? 34,
                          isButtonOutline: widget.outlineAddCart ?? false,
                          onTap: () => _handleAddToCart(context),
                        )
                  : null,
              rating: enableRating!
                  ? buildRating(context,
                      product: widget.product!, color: widget.subTextColor)
                  : null,
              category: enableCategory!
                  ? buildCategory(context,
                      product: widget.product!, color: widget.subTextColor)
                  : Container(),
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemVerticalCenter:
            return ProductVerticalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
                thumbSizes: thumbSizes,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCart: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : buildAddCart(
                          context,
                          product: widget.product!,
                          enableIconCart: widget.enableIconCart!,
                          icon: widget.iconAddCart,
                          text: translate('product_add_to_cart'),
                          isButtonOutline: widget.outlineAddCart ?? true,
                          radius: widget.radiusAddCart ?? 8,
                          onTap: () => _handleAddToCart(context),
                        )
                  : null,
              rating: enableRating!
                  ? buildRating(context,
                      product: widget.product!, color: widget.subTextColor)
                  : null,
              category: enableCategory!
                  ? buildCategory(context,
                      product: widget.product!, color: widget.subTextColor)
                  : false as Widget,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              type: ProductVerticalItemType.center,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemCardHorizontal:
            bool enablePrice = get(widget.dataTemplate, ['enablePrice'], false);
            double? opacity = ConvertData.stringToDouble(
                get(widget.dataTemplate, ['opacity'], 0.6), 0.6);
            dynamic opacityColor =
                get(widget.dataTemplate, ['opacityColor'], Colors.black);
            Color colorOpacity = opacityColor is Color
                ? opacityColor
                : opacityColor is Map
                    ? ConvertData.fromRGBA(
                        get(opacityColor, [themeModeKey], {}), Colors.black)
                    : Colors.black;

            return ProductCardHorizontalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
                thumbSizes: thumbSizes,
              ),
              category: enableCategory!
                  ? buildCategory(context,
                      product: widget.product!,
                      color: widget.subTextColor ?? Colors.white)
                  : null,
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.titleSmall!
                    .copyWith(color: widget.textColor ?? Colors.white),
              ),
              price: enablePrice
                  ? buildPrice(
                      context,
                      product: widget.product!,
                      priceStyle: stylePrice,
                      saleStyle: styleSale,
                      regularStyle: styleRegular,
                      styleFrom: styleTextFrom,
                    )
                  : null,
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCart: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : buildAddCart(
                          context,
                          product: widget.product!,
                          enableIconCart: widget.enableIconCart ?? false,
                          icon: widget.iconAddCart,
                          text: translate('product_buy_product'),
                          radius: widget.radiusAddCart ?? 8,
                          isButtonOutline: widget.outlineAddCart ?? false,
                          onTap: () => _handleAddToCart(context),
                        )
                  : null,
              width: widget.width,
              padding: widget.padding ?? paddingMedium,
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              radiusImage: widget.radiusImage ?? 8,
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              opacity: opacity,
              colorOpacity: colorOpacity,
              onClick: () => _navigate(context),
            );
          case Strings.productItemCardVertical:
            List<ProductBrand?> brands = widget.product?.brands ?? [];
            return ProductCardVerticalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
                thumbSizes: thumbSizes,
              ),
              category: enableCategory!
                  ? buildCategory(context,
                      product: widget.product!,
                      color: widget.subTextColor ?? Colors.white)
                  : null,
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.titleSmall!
                    .copyWith(color: widget.textColor ?? Colors.white),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              rating: enableRating!
                  ? buildRating(context,
                      product: widget.product!, color: widget.subTextColor)
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCart: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : SizedBox(
                          width: double.infinity,
                          child: buildAddCart(
                            context,
                            product: widget.product!,
                            enableIconCart: widget.enableIconCart ?? false,
                            icon: widget.iconAddCart,
                            text: translate('product_buy_product'),
                            radius: widget.radiusAddCart ?? 8,
                            isButtonOutline: widget.outlineAddCart ?? false,
                            onTap: () => _handleAddToCart(context),
                          ),
                        )
                  : null,
              tagExtra: brands.isNotEmpty
                  ? buildBrand(
                      context,
                      product: widget.product,
                      color: widget.subTextColor,
                    )
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              border: widget.border,
              color: widget.background,
              boxShadow: widget.boxShadow ?? initBoxShadow,
              padding: widget.padding ?? paddingMedium,
              width: widget.width,
              onClick: () => _navigate(context),
            );
          case Strings.productItemCurve:
            double pad =
                widget.padding != null ? widget.padding!.horizontal : 16;
            double widthImage = widget.width - pad;
            double heightImage = (widthImage * widget.height) / widget.width;
            return ProductCurveItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widthImage,
                height: heightImage,
                borderRadius: widget.radiusImage ?? 12,
                fit: fit,
                thumbSizes: thumbSizes,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCart: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : buildAddCart(
                          context,
                          product: widget.product!,
                          icon: widget.iconAddCart ?? FeatherIcons.plus,
                          radius: widget.radiusAddCart ?? 8,
                          isButtonOutline: widget.outlineAddCart ?? false,
                          onTap: () => _handleAddToCart(context),
                          enableAllRadius: false,
                        )
                  : null,
              rating: enableRating!
                  ? buildRating(context,
                      product: widget.product!,
                      showNumber: true,
                      color: widget.subTextColor)
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 16),
              border: widget.border,
              boxShadow: widget.boxShadow ?? initBoxShadow,
              color: widget.background ?? theme.cardColor,
              padding: widget.padding ?? paddingTiny,
              onClick: () => _navigate(context),
            );
          case Strings.productItemHorizontalNew:
            return ProductHorizontalItemNew(
              product: widget.product,
              discountPercent: getPercent(
                  ConvertData.stringToDouble(widget.product?.salePrice),
                  ConvertData.stringToDouble(widget.product?.regularPrice)),
              image: GestureDetector(
                onTap: () {
                  _navigatePopup(context);
                },
                child: buildImage(
                  context,
                  product: widget.product!,
                  width: 128,
                  height: 128,
                  borderRadius: widget.radiusImage,
                  fit: fit,
                  thumbSizes: thumbSizes,
                ),
              ),
              name: GestureDetector(
                onTap: () {
                  _navigatePopup(context);
                },
                child: buildName(
                  context,
                  product: widget.product!,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: widget.textColor),
                ),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCard: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : buildAddCart(
                          context,
                          product: widget.product!,
                          icon: widget.iconAddCart ?? FeatherIcons.plus,
                          radius: 1, //widget.radiusAddCart ?? 8,
                          isButtonOutline: widget.outlineAddCart ?? false,
                          onTap: () => showQuickView(
                            context: context,
                            product: widget.product!,
                            settingStore: _settingStore,
                          ),
                        )
                  : null,
              rating: enableRating!
                  ? buildRating(context,
                      product: widget.product!, color: widget.subTextColor)
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background ?? Colors.transparent,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemGridNew:
            return ProductGridNew(
              discountPercent: getPercent(
                  ConvertData.stringToDouble(widget.product?.salePrice),
                  ConvertData.stringToDouble(widget.product?.regularPrice)),
              image: GestureDetector(
                onTap: () {
                  _navigatePopup(context);
                },
                child: buildImage(
                  context,
                  product: widget.product!,
                  width: 128,
                  height: 128,
                  borderRadius: widget.radiusImage,
                  fit: fit,
                  thumbSizes: thumbSizes,
                ),
              ),
              name: GestureDetector(
                onTap: () {
                  _navigatePopup(context);
                },
                child: buildName(
                  context,
                  product: widget.product!,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: widget.textColor),
                ),
              ),
              price: buildPrice(
                shouldFit: true,
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCard: enableAddCart
                  ? _loading
                      ? _buildLoading(context)
                      : buildAddCart(
                          context,
                          product: widget.product!,
                          icon: widget.iconAddCart ?? FeatherIcons.plus,
                          radius: 1, //widget.radiusAddCart ?? 8,
                          isButtonOutline: widget.outlineAddCart ?? false,
                          onTap: () => _handleAddToCart(context),
                        )
                  : null,
              rating: enableRating!
                  ? buildRating(context,
                      product: widget.product!, color: widget.subTextColor)
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background ?? Colors.transparent,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemRelated:
            return ProductRelatedNew(
              image: GestureDetector(
                onTap: () {
                  _navigatePopup(context);
                },
                child: buildImage(
                  context,
                  product: widget.product!,
                  width: 96,
                  height: 96,
                  borderRadius: widget.radiusImage,
                  fit: fit,
                  thumbSizes: thumbSizes,
                ),
              ),
              name: GestureDetector(
                onTap: () {
                  _navigatePopup(context);
                },
                child: buildName(
                  context,
                  product: widget.product!,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: widget.textColor)
                      .apply(fontSizeFactor: 0.8),
                ),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background ?? Colors.transparent,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          default:
            return GestureDetector(
              onTap: () {
                _navigatePopup(context);
              },
              child: ProductContainedItem(
                image: buildImage(
                  context,
                  product: widget.product!,
                  width: 128,
                  height: 128,
                  borderRadius: widget.radiusImage,
                  fit: fit,
                  thumbSizes: thumbSizes,
                ),
                name: GestureDetector(
                  onTap: () {
                    _navigatePopup(context);
                  },
                  child: buildName(
                    context,
                    product: widget.product!,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: widget.textColor),
                  ),
                ),
                price: buildPrice(
                  context,
                  product: widget.product!,
                  priceStyle: stylePrice,
                  saleStyle: styleSale,
                  regularStyle: styleRegular,
                  styleFrom: styleTextFrom,
                ),
                tagExtra: enableLabelNew! || enableLabelSale!
                    ? buildTagExtra(
                        context,
                        product: widget.product!,
                        enableNew: enableLabelNew,
                        newColor: widget.labelNewColor,
                        newTextColor: widget.labelNewTextColor,
                        newRadius: widget.labelNewRadius,
                        enableSale: enableLabelSale,
                        saleColor: widget.labelSaleColor,
                        saleTextColor: widget.labelSaleTextColor,
                        saleRadius: widget.labelSaleRadius,
                      )
                    : null,
                wishlist: buildWishlist(
                  context,
                  product: widget.product!,
                  color: widget.wishlistColor ?? Colors.black,
                  isSelected: existWishList(productId: widget.product!.id),
                  onTap: () => _wishlist(context),
                ),
                addCard: enableAddCart
                    ? _loading
                        ? _buildLoading(context)
                        : buildAddCart(
                            context,
                            product: widget.product!,
                            icon: widget.iconAddCart ?? FeatherIcons.plus,
                            radius: widget.radiusAddCart ?? 8,
                            isButtonOutline: widget.outlineAddCart ?? false,
                            onTap: () => _handleAddToCart(context),
                          )
                    : null,
                rating: enableRating!
                    ? buildRating(context,
                        product: widget.product!, color: widget.subTextColor)
                    : null,
                quantity: enableQuantity
                    ? buildQuantityItem(
                        context,
                        product: widget.product!,
                        quantity: _quantity,
                        onChanged: (int value) => setState(() {
                          _quantity = value;
                        }),
                      )
                    : null,
                width: widget.width,
                borderRadius: BorderRadius.circular(widget.radius ?? 0),
                border: widget.border,
                boxShadow: widget.boxShadow,
                color: widget.background ?? Colors.transparent,
                padding: widget.padding,
                onClick: () => _navigate(context),
              ),
            );
        }
      },
    );
  }

  _buildLoading(BuildContext context) {
    return SizedBox(
        width: 32, height: 32, child: Center(child: entryLoading(context)));
  }
}

showQuickView(
    {required BuildContext context,
    required SettingStore settingStore,
    required Product product}) async {
  AlertDialog alert = AlertDialog(
    content: SizedBox(
      width: 500, // Set the width to a specific value
      height: 500, // Set the height to a specific value
      child: ProductScreen(
        store: settingStore,
        args: {'product': product},
        isQuickView: true,
      ),
    ),
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showQuickViewWithOutProduct(
    {required BuildContext context,
    required SettingStore settingStore,
    required int   id}) async {
  AlertDialog alert = AlertDialog(
    content: SizedBox(
      width: 500, // Set the width to a specific value
      height: 500, // Set the height to a specific value
      child: ProductScreen(
        store: settingStore,
        args: {'id': id},
        isQuickView: true,
      ),
    ),
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
