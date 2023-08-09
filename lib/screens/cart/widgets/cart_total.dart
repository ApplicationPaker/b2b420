import 'package:cirilla/models/cart/cart.dart';
import 'package:flutter/material.dart';

import '../../../mixins/utility_mixin.dart';
import '../../../types/types.dart';
import '../../../utils/app_localization.dart';
import '../../../utils/currency_format.dart';

class CartTotal extends StatelessWidget {
  final CartData cartData;
  const CartTotal({Key? key, required this.cartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? subTotal = get(cartData.totals, ['total_items'], '0');

    String? subTax = get(cartData.totals, ['total_tax'], '0');

    String? totalPrice = get(cartData.totals, ['total_price'], '0');

    int? unit = get(cartData.totals, ['currency_minor_unit'], 0);

    String? currencyCode = get(cartData.totals, ['currency_code'], null);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Column(
      children: [
        buildCartTotal(
          title: translate('cart_sub_total'),
          price: convertCurrency(context, unit: unit, currency: currencyCode, price: subTotal)!,
          style: textTheme.titleSmall,
        ),
        ...List.generate(
          cartData.coupons!.length,
          (index) {
            String? coupon = get(cartData.coupons!.elementAt(index), ['totals', 'total_discount'], '0');
            String? couponTitle = get(cartData.coupons!.elementAt(index), ['code'], '');
            return Column(
              children: [
                const SizedBox(height: 4),
                buildCartTotal(
                  title: translate('cart_code_coupon', {'code': couponTitle!}),
                  price: '- ${convertCurrency(context, unit: unit, currency: currencyCode, price: coupon)}',
                  style: textTheme.bodyMedium,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 4),
        ...List.generate(
          cartData.shippingRate!.length,
          (index) {
            ShippingRate shippingRate = cartData.shippingRate!.elementAt(index);

            List data = shippingRate.shipItem!;
            return Column(
              children: List.generate(data.length, (index) {
                ShipItem dataShipInfo = data.elementAt(index);

                String name = get(dataShipInfo.name, [], '');

                String? price = get(dataShipInfo.price, [], '');

                bool selected = get(dataShipInfo.selected, [], '');

                String? currencyCode = get(dataShipInfo.currencyCode, [], '');

                return selected
                    ? buildCartTotal(
                        title: translate(name),
                        price: convertCurrency(context, unit: unit, currency: currencyCode, price: price)!,
                        style: textTheme.bodyMedium,
                      )
                    : Container();
              }),
            );
          },
        ),
        const SizedBox(height: 31),
        buildCartTotal(
            title: translate('cart_tax'),
            price: convertCurrency(context, unit: unit, currency: currencyCode, price: subTax)!,
            style: textTheme.titleSmall),
        const SizedBox(height: 4),
        buildCartTotal(
          title: translate('cart_total'),
          price: convertCurrency(context, unit: unit, currency: currencyCode, price: totalPrice)!,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}

Widget buildCartTotal({BuildContext? context, required String title, required String price, TextStyle? style}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(title, style: style),
      ),
      Text(price, style: style)
    ],
  );
}
