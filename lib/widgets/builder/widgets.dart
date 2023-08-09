import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/profile/widgets/icon_notification.dart';
import 'package:cirilla/screens/search/product_search.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/auth/location_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/builder/product_video_shop/product_video_shop.dart';
import 'package:cirilla/widgets/builder/youtube/youtube.dart';
import 'package:cirilla/widgets/cirilla_appbar.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../constants/color_block.dart';
import '../../store/setting/setting_store.dart';
import 'banner/banner.dart';
import 'button/button.dart';
import 'divider/divider.dart';
import 'post/post.dart';
import 'product_search/product_search.dart';
import 'post_search/post_search.dart';
import 'text/text.dart';
import 'testimonial/testimonial.dart';
import 'slideshow/slideshow.dart';
import 'post_category/post_category.dart';
import 'html/html.dart';
import 'post_archive/post_archive.dart';
import 'post_comment/post_comment.dart';
import 'post_author/post_author.dart';
import 'post_tag/post_tag.dart';
import 'post_tab/post_tab.dart';
import 'heading/heading.dart';
import 'subscribe/subscribe.dart';
import 'social/social.dart';
import 'product_newest/product_newest.dart';
import 'product_best_seller/product_best_seller.dart';
import 'product_top_rated/product_top_rated.dart';
import 'product_sale/product_sale.dart';
import 'product_featured/product_featured.dart';
import 'product_hand_picked/product_hand_picked.dart';
import 'product_recently/product_recently.dart';
import 'product_tag/product_tag.dart';
import 'product_tab/product_tab.dart';
import 'product_by_category/product_by_category.dart';
import 'product_category/product_category.dart';
import 'countdown/countdown.dart';
import 'spacer/spacer.dart';
import 'icon_box/icon_box.dart';
import 'vendor_best_selling/vendor_best_selling.dart';
import 'vendor_top_rated/vendor_top_rated.dart';
import 'video/video.dart';
import 'webview/webview.dart';
import 'page_block/page_block.dart';
import 'post_block/post_block.dart';
import 'brand/brand.dart';
import 'tab_basic/tab_basic.dart';

class Widgets {
  static const String slideshow = 'slideshow';
  static const String divider = 'divider';
  static const String category = 'category';
  static const String banner = 'banner';
  static const String text = 'text';
  static const String button = 'button';
  static const String spacer = 'spacer';

  static const String productSearch = 'product-search';
  static const String postSearch = 'post-search';
  static const String product = 'product';
  static const String productCategory = 'product-category';
  static const String postCategory = 'post-category';
  static const String post = 'post';
  static const String testimonial = 'testimonial';
  static const String vendor = 'vendor';
  static const String countdown = 'countdown';
  static const String iconBox = 'icon-box';
  static const String html = 'html';
  static const String postArchive = 'post-archive';
  static const String postComment = 'post-comment';
  static const String postTag = 'post-tag';
  static const String postAuthor = 'post-author';
  static const String postTab = 'post-tab';
  static const String heading = 'heading';
  static const String subscribe = 'subscribe';
  static const String social = 'social';
  static const String productNewest = 'product-newest';
  static const String productBestSeller = 'product-best-seller';
  static const String productTopRated = 'product-top-rated';
  static const String productSale = 'product-sale';
  static const String productFeatured = 'product-featured';
  static const String productHandPicked = 'product-hand-picked';
  static const String productRecently = 'product-recently';
  static const String productByCategory = 'product-by-category';
  static const String productTag = 'product-tag';
  static const String productTab = 'product-tab';
  static const String vendorBestSelling = 'vendor-best-selling';
  static const String vendorTopRated = 'vendor-top-rated';
  static const String video = 'video';
  static const String youtube = 'video-youtube';
  static const String webview = 'webview';
  static const String pageBlock = 'page-block';
  static const String postBlock = 'post-block';
  static const String brand = 'brand';
  static const String tabBasic = 'tab-basic';
  static const String productVideoShop = 'video-shopping';

  void logout(AuthStore authStore) async {
    await authStore.logout();
  }

  SliverList buildWidgets(BuildContext context,
      {required List<String> widgetIds,
      Map<String, WidgetConfig>? widgets,
      Widget? footer}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          String id = widgetIds[index];
          WidgetConfig? widget = widgets![id];
          return Column(
            children: [
              buildWidget(widget),
              if (footer != null) footer,
              const SizedBox(
                height: 60,
              )
            ],
          );
        },
        childCount: widgetIds.length,
      ),
    );
  }

  Widget buildWidget(WidgetConfig? widget) {
    switch (widget?.type) {
      case postCategory:
        return PostCategoryWidget(
          widgetConfig: widget,
        );
      case post:
        return PostWidget(
          widgetConfig: widget,
        );
      case text:
        return TextWidget(
          widgetConfig: widget,
        );
      case button:
        return ButtonWidget(
          widgetConfig: widget,
        );
      case banner:
        return BannerWidget(
          widgetConfig: widget,
        );
      case divider:
        return DividerWidget(
          widgetConfig: widget,
        );
      case productSearch:
        return ProductSearchWidget(
          widgetConfig: widget,
        );
      case postSearch:
        return PostSearchWidget(
          widgetConfig: widget!,
        );
      case testimonial:
        return TestimonialWidget(
          widgetConfig: widget,
        );
      case slideshow:
        return SlideshowWidget(
          widgetConfig: widget,
        );
      case html:
        return HtmlWidget(
          widgetConfig: widget,
        );
      case postArchive:
        return PostArchiveWidget(
          widgetConfig: widget,
        );
      case postComment:
        return PostCommentWidget(
          widgetConfig: widget,
        );
      case postTag:
        return PostTagWidget(
          widgetConfig: widget,
        );
      case postAuthor:
        return PostAuthorWidget(
          widgetConfig: widget,
        );
      case postTab:
        return PostTabWidget(
          widgetConfig: widget,
        );
      case heading:
        return HeadingWidget(
          widgetConfig: widget,
        );
      case subscribe:
        return SubscribeWidget(
          widgetConfig: widget,
        );
      case social:
        return SocialWidget(
          widgetConfig: widget,
        );
      case productNewest:
        return ProductNewestWidget(
          widgetConfig: widget,
          layoutOverride: Strings.productLayoutHomePageList,
        );
      case productTab:
        return ProductTabWidget(
          widgetConfig: widget,
        );
      case productCategory:
        return ProductCategoryWidget(
          widgetConfig: widget,
        );
      case productBestSeller:
        return ProductBestSellerWidget(
          widgetConfig: widget,
        );
      case productTopRated:
        return ProductTopRatedWidget(
          widgetConfig: widget,
        );
      case productSale:
        return ProductSaleWidget(
          widgetConfig: widget,
        );
      case productFeatured:
        return ProductFeaturedWidget(
          widgetConfig: widget,
        );
      case productHandPicked:
        return ProductHandPickedWidget(
          widgetConfig: widget,
        );
      case productRecently:
        return ProductRecentlyWidget(
          widgetConfig: widget,
        );
      case productTag:
        return ProductTagWidget(
          widgetConfig: widget,
        );
      case productByCategory:
        return ProductByCategoryWidget(
          widgetConfig: widget,
        );
      case countdown:
        return CountdownWidget(
          widgetConfig: widget,
        );
      case spacer:
        return SpacerWidget(
          widgetConfig: widget,
        );
      case iconBox:
        return IconBoxWidget(
          widgetConfig: widget,
        );
      case vendorBestSelling:
        return VendorBestSellingWidget(
          widgetConfig: widget,
        );
      case vendorTopRated:
        return VendorTopRatedWidget(
          widgetConfig: widget,
        );
      case video:
        return VideoWidget(
          widgetConfig: widget,
        );
      case youtube:
        return YoutubeWidget(
          widgetConfig: widget,
        );
      case webview:
        return WebviewWidget(
          widgetConfig: widget,
        );
      case pageBlock:
        return PageBlockWidget(
          widgetConfig: widget,
        );
      case postBlock:
        return PostBlockWidget(
          widgetConfig: widget,
        );
      case brand:
        return BrandWidget(
          widgetConfig: widget,
        );
      case tabBasic:
        return TabBasicWidget(
          widgetConfig: widget,
        );
      case productVideoShop:
        return ProductVideoShopWidget(
          widgetConfig: widget,
        );
      default:
        return Text(widget?.type ?? 'No widget found!');
    }
  }
}

class _LocationButton extends StatelessWidget {
  final Color? color;

  const _LocationButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        LocationStore locationStore =
            Provider.of<AuthStore>(context).locationStore;
        String location = locationStore.location.address ?? '';
        return InkResponse(
          onTap: () => Navigator.pushNamed(context, LocationScreen.routeName),
          child: Row(
            children: [
              Icon(FeatherIcons.mapPin, size: 16, color: theme.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location.isNotEmpty
                      ? location
                      : translate('search_select_location'),
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ButtonNavigate extends StatelessWidget with NavigationMixin {
  final IconData icon;
  final Map<String, dynamic>? action;

  const _ButtonNavigate({Key? key, required this.icon, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => navigate(context, action),
    );
  }
}

dynamic buildHomeAppBar(
  BuildContext context, {
  required Data data,
  Map? extraData,
  String? type,
  bool isScrolledToTop = false,
  String themeModeKey = 'value',
  String? languageKey = 'text',
}) {
  final store = Provider.of<SettingStore>(context);
  Color appbarColorOnTop = ConvertData.fromRGBA(
      get(data.configs, ['appbarColorOnTop', themeModeKey]),
      Colors.transparent);

  Color iconAppbarColorOnTop = ConvertData.fromRGBA(
      get(data.configs, ['iconAppbarColorOnTop', themeModeKey]), Colors.white);

  // Center title
  bool? centerTitle = get(data.configs, ['centerLogo'], true);

  // Enable Logo
  bool enableLogo = get(data.configs, ['enableLogo'], true);

  bool enableLocation = get(data.configs, ['enableLocation'], false);

  // Logo Text
  String logoText = get(
      data.configs, ['logoText', languageKey], extraData?['title'] ?? 'Home');

  // Logo Image
  String? imageLogo = get(data.configs, ['imageLogo', 'src'], '');
  String? imageLogoDark = get(data.configs, ['imageLogoDark', 'src'], '');
  String? logo = themeModeKey == 'value' ? imageLogo : imageLogoDark;

  // Logo Width
  double? logoWidth =
      ConvertData.stringToDouble(get(data.configs, ['logoWidth'], 122));

  // Logo Width
  double? logoHeight =
      ConvertData.stringToDouble(get(data.configs, ['logoHeight'], 50));

  // Enable Sidebar
  bool? enableSidebar = get(data.configs, ['enableSidebar'], true);

  // Sidebar icon
  String iconSideBar =
      get(data.configs, ['iconSideBar', 'name'], extraData?['icon'] ?? 'menu');
  String iconTypeSideBar =
      get(data.configs, ['iconSideBar', 'type'], 'feature');

  // Sidebar image
  String? imageSidebar = get(data.configs, ['imageSidebar', 'src'], '');

  // Enable/ Disable Blog search
  bool enableBlogSearch = get(data.configs, ['enableBlogSearch'], false);

  // Enable / Disable Blog search
  bool enableProductSearch = get(data.configs, ['enableProductSearch'], false);

  // Enable / Disable Blog wishlist
  bool enableBlogWishlist = get(data.configs, ['enableBlogWishlist'], false);

  // Enable / Disable Product wishlist
  bool enableProductWishlist =
      get(data.configs, ['enableProductWishlist'], false);

  // Enable / Disable Notification
  bool enableNotification = get(data.configs, ['enableNotification'], false);

  // Enable / Disable cart
  bool enableCart = get(data.configs, ['enableCart'], false);

  // Enable / Disable cart count
  bool? enableCartCount = get(data.configs, ['enableNumberCart'], true);

  // Cart Icon
  Map iconCart = get(
      data.configs, ['iconCart'], {'type': 'feather', 'name': 'shopping-cart'});

  // Cart Image
  String? imageCart = get(data.configs, ['imageCart', 'src'], '');

  bool isDrawer = AwesomeDrawerBar.of(context) != null;

  TranslateType translate = AppLocalizations.of(context)!.translate;

  TextStyle? textStyle = Theme.of(context).appBarTheme.titleTextStyle;

  // ==== Leading
  Widget leading = imageSidebar != ""
      ? InkWell(
          onTap: () => isDrawer
              ? AwesomeDrawerBar.of(context)!.toggle()
              : Navigator.of(context).pop(),
          child: CirillaCacheImage(
            imageSidebar,
            width: 32,
            height: 32,
          ),
        )
      : IconButton(
          iconSize: 35,
          alignment: AlignmentDirectional.center,
          icon: isDrawer && iconSideBar == 'menu'
              ? AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: AwesomeDrawerBar.of(context)!.animationController!,
                  color: Colors.white,
                )
              : CirillaIconBuilder(
                  data: {
                    'name': iconSideBar,
                    'type': iconTypeSideBar,
                  },
                  color: Colors.white,
                ),
          onPressed: () => isDrawer
              ? AwesomeDrawerBar.of(context)!.toggle()
              : Navigator.of(context).pop(),
        );

  //  ==== Title
  Widget? title = enableLogo
      ? logo != null && logo != ''
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => store.setTab('screens_home'),
              child: Image.asset(
                "assets/images/icon.png",
                height: 75,
              ),
            )
          // CirillaCacheImage(
          //     logo,
          //     width: logoWidth,
          //     height: logoHeight,
          //     fit: BoxFit.contain,
          //   )
          : Text(
              TextDynamic.getTextDynamic(context, text: logoText),
              style: const TextStyle(color: Colors.white),
            )
      : enableLocation
          ? _LocationButton(
              color: type == Strings.appbarFixed && isScrolledToTop
                  ? iconAppbarColorOnTop
                  : textStyle?.color)
          : null;

  // ==== Actions
  List<Widget> actions = [
    if (enableBlogSearch)
      IconButton(
        icon: const Icon(
          FeatherIcons.search,
          color: Colors.white,
        ),
        onPressed: () async {
          await showSearch<String?>(
            context: context,
            delegate: PostSearchDelegate(context, translate),
          );
        },
      ),
    if (enableBlogWishlist)
      const _ButtonNavigate(
        icon: FeatherIcons.heart,
        action: {
          'type': 'tab',
          'route': '/',
          'args': {'key': 'screens_postWishlist'}
        },
      ),
    // if (enableProductSearch || true)
    //   IconButton(
    //     icon: const Icon(
    //       FeatherIcons.search,
    //       color: Colors.white,
    //     ),
    //     onPressed: () async {
    //       await showSearch<String?>(
    //         context: context,
    //         delegate: ProductSearchDelegate(context, translate),
    //       );
    //     },
    //   ),
    // const SizedBox(
    //   width: 8,
    // ),
    if (enableProductWishlist)
      const _ButtonNavigate(
        icon: FeatherIcons.heart,
        action: {
          'type': 'tab',
          'route': '/',
          'args': {'key': 'screens_wishlist'}
        },
      ),
    avatarWidget(context),
    const SizedBox(
      width: 8,
    ),
    if (enableCart)
      CirillaCartIcon(
        icon: CirillaIconBuilder(
          data: iconCart,
          size: 20,
          color: Colors.white,
        ),
        enableCount: enableCartCount,
        cartImage: imageCart!.isNotEmpty
            ? CirillaCacheImage(
                imageCart,
                width: 32,
                height: 64,
              )
            : null,
        color: Colors.transparent,
      ),
    if (enableNotification) const IconNotification(),
  ];

  switch (type) {
    case Strings.appbarFixed:
      return CirillaAppbar(
        color: appbarColorOnTop,
        isScrolledToTop: isScrolledToTop,
        child: AppBar(
          iconTheme: isScrolledToTop
              ? const IconThemeData(
                  color: Colors.white,
                )
              : Theme.of(context).appBarTheme.iconTheme,
          titleTextStyle: isScrolledToTop
              ? textStyle?.copyWith(color: iconAppbarColorOnTop)
              : textStyle,

          backgroundColor: ColorBlock.b2Black,
          elevation: 0,
          // leading: enableSidebar! ? leading : null,
          title: title,
          leading: leading,
          centerTitle: centerTitle,
          actions: actions,
        ),
      );
    default:
      return SliverAppBar(
        floating: type == Strings.appbarFloating,
        elevation: 0,
        primary: true,
        leading: leading,
        centerTitle: true,
        title: title,
        actions: actions,
        backgroundColor: ColorBlock.b2Black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              padding: const EdgeInsets.all(7.0),
              child: TextField(
                readOnly: true,
                onTap: () async => await showSearch<String?>(
                  context: context,
                  delegate: ProductSearchDelegate(context, translate),
                ),
                decoration: InputDecoration(
                  hintText:
                      '${AppLocalizations.of(context)?.translate('product_category_search')}...',
                  filled: true,
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}

avatarWidget(BuildContext context) {
  var authStore = Provider.of<AuthStore>(context);
  var settingStore = Provider.of<SettingStore>(context);
  bool enableRegister =
      true; //getConfig(_settingStore, ['enableRegister'], true);
  TranslateType translate = AppLocalizations.of(context)!.translate;
  var alignHeader = "center";
  return authStore.isLogin
      ? GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            settingStore.setTab('screens_profile');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CirillaCacheImage(
              authStore.user!.avatar,
              width: 24,
              height: 24,
              fit: BoxFit.fitWidth,
            ),
          ),
        )
      : GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(LoginScreen.routeName, arguments: {
            'showMessage': ({String? message}) {
              avoidPrint('112');
            }
          }),
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    Assets.noAvatar,
                  )),
            ),
          ),
        );
}
