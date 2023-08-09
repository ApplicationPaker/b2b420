import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/widgets/cirilla_badge.dart';
import 'package:flutter/material.dart';

class CartCountVideoShop extends StatelessWidget {

  const CartCountVideoShop({Key? key, required this.cartCount}) : super(key: key);
  final int cartCount;
  @override
  Widget build(BuildContext context) {
    return CirillaBadge(
      size: 18,
      padding: paddingHorizontalTiny,
      label: "$cartCount",
      type: CirillaBadgeType.error,
    );
  }
}
