import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FeaturedImage extends StatefulWidget with Utility {
  final List<Map<String, dynamic>>? images;
  final double? width;
  final int index;
  final double? height;

  const FeaturedImage({
    Key? key,
    this.images,
    required this.index,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<FeaturedImage> createState() => _FeaturedImageState();
}

class _FeaturedImageState extends State<FeaturedImage> with Utility {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> images = widget.images ?? [];
    String image = images.isNotEmpty
        ? get(
            images[widget.index], ['woocommerce_thumbnail'], Assets.noImageUrl)
        : Assets.noImageUrl;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InteractiveViewer(
                  child: CirillaCacheImage(
                    image,
                    width: double.infinity,
                    height: 400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: CirillaCacheImage(
        image,
        width: 100,
        height: 150,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
