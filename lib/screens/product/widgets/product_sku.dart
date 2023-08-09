import 'package:cirilla/models/product/product.dart';
import 'package:flutter/material.dart';

class ProductSku extends StatelessWidget {
  final Product? product;
  final String? align;

  const ProductSku({
    Key? key,
    this.product,
    this.align = 'left',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _productSku(context, product: product!);
  }

  Widget _productSku(BuildContext context, {required Product product}) {
    TextAlign textAlign = align == 'center'
        ? TextAlign.center
        : align == 'right'
            ? TextAlign.end
            : TextAlign.start;
    return Text(
      product.sku ?? '',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: textAlign,
    );
  }
}
