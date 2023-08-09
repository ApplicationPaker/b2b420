import 'package:cirilla/screens/cart/widgets/cart_shipping.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CheckoutViewShippingMethods extends StatelessWidget {
  final CartStore cartStore;

  const CheckoutViewShippingMethods({Key? key, required this.cartStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => CartShipping(
        cartStore: cartStore,
        cartData: cartStore.cartData,
        changeAddress: false,
      ),
    );
  }
}
