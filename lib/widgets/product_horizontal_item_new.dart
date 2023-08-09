import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/screens/product/widgets/product_status.dart';
import 'package:flutter/material.dart';
import 'package:ui/product/product_item.dart';

/// A post widget display full width on the screen
///
class ProductHorizontalItemNew extends ProductItem {
  /// Widget image
  final Widget image;
  final double? discountPercent;
  final Product? product;

  /// Widget name. It must required
  final Widget name;

  /// Widget price
  final Widget price;

  /// Widget rating
  final Widget? rating;

  /// Widget wishlist
  final Widget? wishlist;

  /// Widget button Add card
  final Widget? addCard;

  /// Widget extra tags in information
  final Widget? tagExtra;

  /// Widget quantity
  final Widget? quantity;

  /// Width item
  final double width;

  /// shadow card
  final List<BoxShadow>? boxShadow;

  /// Border of item post
  final Border? border;

  /// Color Card of item post
  final Color? color;

  /// Border of item post
  final BorderRadius? borderRadius;

  /// Function click item
  final Function onClick;

  /// Padding content
  final EdgeInsetsGeometry? padding;

  /// Create Product Contained Item
  const ProductHorizontalItemNew({
    Key? key,
    this.product,
    required this.image,
    required this.name,
    this.discountPercent,
    required this.onClick,
    required this.price,
    this.rating,
    this.wishlist,
    this.addCard,
    this.tagExtra,
    this.quantity,
    this.width = 300,
    this.boxShadow,
    this.border,
    this.color = Colors.transparent,
    this.borderRadius,
    this.padding,
  }) : super(
          key: key,
          colorProduct: color,
          boxShadowProduct: boxShadow,
          borderProduct: border,
          borderRadiusProduct: borderRadius,
        );

  @override
  Widget buildLayout(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => onClick(),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            color: Colors.grey.shade100,
            elevation: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      image,
                      if (discountPercent != 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset(
                                  Assets.saleBadge,
                                  height: 30,
                                  width: 100,
                                ),
                                Text(
                                  '${discountPercent?.toStringAsFixed(1)}%',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                              ]),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    // padding: padding ?? EdgeInsets.zero,
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        name,
                        if (rating != null)
                          const SizedBox(
                            height: 8,
                          ),
                        rating ?? Container(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  price,
                                  Container(
                                    color: Colors.grey.shade300,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: addCard ?? Container(),
                            )
                          ],
                        ),
                        if (product?.id != null)
                          ProductStatus(
                            product: product,
                            typeStatus: 'text',
                          )
                        // if (quantity != null) const SizedBox(height: 12),
                        // quantity ?? Container(),
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
