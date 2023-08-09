import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget with ProductMixin {
  final Product? product;
  final String? align;

  const ProductPrice({Key? key, this.product, this.align = 'left'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AlignmentDirectional alignment = align == 'right'
        ? AlignmentDirectional.centerEnd
        // ? Alignment.centerRight
        : align == 'center'
            ? AlignmentDirectional.center
            : AlignmentDirectional.centerStart;
    return Container(
      alignment: alignment,
      child: buildPrice(
        context,
        product: product!,
        regularStyle: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
        saleStyle: theme.textTheme.titleMedium!.copyWith(color: ColorBlock.red),
        priceStyle: theme.textTheme.titleMedium,
        styleFrom: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
        enablePercentSale: true,
        spacing: 17,
        shimmerWidth: 20,
        shimmerHeight: 90,
      ),
    );
  }
}
