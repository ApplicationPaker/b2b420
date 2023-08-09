import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_localization.dart';
import 'cart_count.dart';

class AddCartVideoShop extends StatefulWidget {
  const AddCartVideoShop({
    Key? key,
    required this.videoId,
    required this.stockStatus,
  }) : super(key: key);
  final int? videoId;
  final String stockStatus;

  @override
  State<AddCartVideoShop> createState() => _AddCartVideoShopState();
}

class _AddCartVideoShopState extends State<AddCartVideoShop> with CartMixin, SnackMixin, NavigationMixin {
  late CartStore _cartStore;
  int _cartCount = 0;

  @override
  void didChangeDependencies() {
     _cartStore = Provider.of<AuthStore>(context).cartStore;
     _cartCount = _cartStore.count ?? 0;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Container(
        margin: const EdgeInsets.only(top: 15.0),
        width: 60.0,
        height: 60.0,
        child: Column(children: [
          InkWell(
            onTap: () async {
              setState(() {
                _cartCount++;
              });
              await _addToCart(translate);

            },
            child: SizedBox(
              width: 35,
              height: 35,
              child: Stack(
                children: [
                  const Icon(Icons.add_shopping_cart_outlined, size: 30.0, color: Colors.white),
                   Align(
                    alignment: Alignment.bottomRight,
                    child: CartCountVideoShop(
                      cartCount: _cartCount,
                    ),
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text("Buy Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.0)),
          )
        ]));
  }

  Future<void> _addToCart(TranslateType translate) async {
   if(widget.stockStatus != 'outofstock'){
     try {
       await addToCart(productId: widget.videoId, qty: 1);
     } catch (e) {
       showError(context, e);
       setState(() {
         _cartCount--;
       });
     }
   }
  }
}
