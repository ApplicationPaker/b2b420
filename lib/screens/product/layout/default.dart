import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';

class ProductLayoutDefault extends StatefulWidget {
  final ScrollController? controller;
  final bool isQuickView;
  final Product? product;
  final Widget? appbar;
  final Widget? bottomBar;
  final Widget? slideshow;
  final List<Widget>? productInfo;
  final bool? extendBodyBehindAppBar;

  final Widget? cartIcon;
  final String? cartIconType;
  final String? floatingActionButtonLocation;

  const ProductLayoutDefault({
    Key? key,
    this.controller,
    this.isQuickView = false,
    this.product,
    this.appbar,
    this.bottomBar,
    this.slideshow,
    this.productInfo,
    this.extendBodyBehindAppBar,
    this.cartIcon,
    this.cartIconType,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  State<ProductLayoutDefault> createState() => _ProductLayoutDefaultState();
}

class _ProductLayoutDefaultState extends State<ProductLayoutDefault>
    with AppBarMixin, ScrollMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: ConvertData.floatingActionButtonLocation(
          widget.floatingActionButtonLocation),
      floatingActionButton:
          widget.cartIcon != null && widget.cartIconType == 'floating'
              ? widget.cartIcon
              : null,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar!,
      primary: true,
      bottomNavigationBar: widget.bottomBar,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: RawScrollbar(
          thumbVisibility: true,
          thumbColor: const Color.fromRGBO(237, 89, 38, 1),
          thickness: 0.6,
          child: CustomScrollView(
            controller: widget.controller,
            slivers: [
              if (widget.slideshow != null && !widget.isQuickView)
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      widget.slideshow!,
                      if (widget.cartIcon != null &&
                          widget.cartIconType == 'pinned')
                        Positioned(
                            bottom: 20, right: 20, child: widget.cartIcon!)
                    ],
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return widget.productInfo![index];
                  },
                  childCount: widget.productInfo!.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
