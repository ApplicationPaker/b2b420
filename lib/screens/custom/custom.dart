import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/home/widgets/builder_widgets.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Handle build widget from config
class CustomScreen extends StatefulWidget {
  static const routeName = '/custom';

  final String? screenKey;
  final Map? extraData;

  const CustomScreen({Key? key, this.screenKey,this.extraData}) : super(key: key);

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  late SettingStore _settingStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_settingStore.data == null ||
            _settingStore.data!.extraScreens == null) return Container();
        String screenKey = widget.screenKey != null
            ? widget.screenKey!.replaceFirst('extraScreens_', '')
            : 'custom';
        final Data? data = _settingStore.data!.extraScreens![screenKey];
        return BuilderWidgets(
          appBarType: 'fixed',
          data: data,
          extraData: widget.extraData,
          hasInnerAppBar: false,
        );
      },
    );
  }
}