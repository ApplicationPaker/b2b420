import 'package:flutter/material.dart';
import 'package:ui/product/product_item.dart';

/// A post widget display full width on the screen
///
class ProductRelatedNew extends ProductItem {
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

  /// Padding content
  final EdgeInsetsGeometry? padding;

  /// Create Product Contained Item
  const ProductRelatedNew({
    Key? key,
    required this.image,
    required this.name,
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
        child: Card(
          color: Colors.grey.shade100,
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: image,
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
