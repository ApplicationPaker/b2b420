import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/home/widgets/builder_widgets.dart';
import 'package:cirilla/screens/product_list/product_list.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Home tab
/// Handle build widget from config
class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  late SettingStore _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_settingStore.data == null ||
            _settingStore.data!.screens == null ||
            (_authStore.loginStore.loading) ||
            (_authStore.registerStore.loading ||
                (_authStore.loadingEditAccount ?? false))) {
          return Container();
        }
        // Home config
        Data? data = _settingStore.data!.screens!['home'];
        final List<String> widgetIdList = [
          'product-category_1618802700325_0u7cfb'
        ];

        Map<String, WidgetConfig>? targetWidgetMapConfig = {};
        targetWidgetMapConfig["product-category_1618802700325_0u7cfb"] = data!
            .widgets!["product-category_1618802700325_0u7cfb"]!
            .copyWith(layout: () => 'grid-wrap');

        final Data targetData = Data(
          configs: data.configs,
          widgetIds: widgetIdList,
          widgets: targetWidgetMapConfig,
        );

        return BuilderWidgets(
          data: targetData,
          footer: CustomPolicyFooter(withWhatsAppIcon: true),
        );
      },
      warnWhenNoObservables: false,
    );
  }
}
