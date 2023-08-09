import 'package:cirilla/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:ui/product/product_item.dart';

/// A post widget display full width on the screen
///
class ProductGridNew extends ProductItem {
  /// Widget image
  final Widget image;

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
  final double? discountPercent;

  /// Padding content
  final EdgeInsetsGeometry? padding;

  /// Create Product Contained Item
  const ProductGridNew({
    Key? key,
    required this.image,
    required this.name,
    required this.onClick,
    required this.price,
    this.discountPercent,
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
        child: Card(
          color: Colors.grey.shade100,
          elevation: 2,
          child: Column(
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
                              Text('${discountPercent?.toStringAsFixed(1)}%',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.white)),
                            ]),
                      )
                  ],
                ),
              ),
              name,
              if (rating != null)
                const SizedBox(
                  height: 8,
                ),
              Row(
                children: [
                  Column(
                    children: [
                      rating ?? Container(),
                      price,
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: addCard ?? Container(),
                  ),
                ],
              ),
              // if (quantity != null) const SizedBox(height: 12),
              // quantity ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
