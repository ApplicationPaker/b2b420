import 'dart:async';
import 'dart:io';

import 'package:cirilla/constants/app.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/models/models.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cirilla/store/store.dart';

class WebviewWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const WebviewWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> with LoadingMixin, NavigationMixin {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _loading = true;

  SettingStore? _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    double heightWindow = MediaQuery.of(context).size.height;

    String themeModeKey = _settingStore?.themeModeKey ?? 'value';
    String language = _settingStore?.locale ?? defaultLanguage;

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    // general config
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    double? height = ConvertData.stringToDouble(get(fields, ['height'], 200), 200);
    String url = ConvertData.stringFromConfigs(get(fields, ['url'], ''), language)!;
    bool syncAuth = get(fields, ['syncAuth'], false);
    bool syncAuthWebToApp = get(fields, ['syncAuthWebToApp'], false);
    List<dynamic> items = get(fields, ['items'], []);

    // Check validate URL
    bool validURL = Uri.parse(url).isAbsolute;

    return Container(
      color: background,
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      height: url.isNotEmpty
          ? height == 0
              ? heightWindow
              : height
          : null,
      child: validURL
          ? Stack(
              children: [
                WebView(
                  // initialUrl: url,
                  userAgent: !syncAuthWebToApp
                      ? null
                      : 'Mozilla/5.0 (Linux; Android 11; LM-V500N Build/RKQ1.210420.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/102.0.5005.125 Mobile Safari/537.36 Cirilla/3.0.0',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);

                    webViewController.clearCache();
                    final cookieManager = CookieManager();
                    cookieManager.clearCookies();

                    if (_authStore.isLogin && syncAuth) {
                      Map<String, String> headers = {"Authorization": "Bearer ${_authStore.token!}"};

                      Map<String, String?> queryParams = {
                        'app-builder-decode': 'true',
                        'redirect': url,
                      };

                      if (_authStore.isLogin) {
                        queryParams.putIfAbsent('app-builder-decode', () => 'true');
                      }

                      if (_settingStore!.isCurrencyChanged) {
                        queryParams.putIfAbsent('currency', () => _settingStore!.currency);
                      }

                      if (_settingStore!.languageKey != "text") {
                        queryParams.putIfAbsent(_authStore.isLogin ? '_lang' : 'lang', () => _settingStore!.locale);
                      }

                      String loginUrl =
                          "${Endpoints.restUrl}${Endpoints.loginToken}?${Uri(queryParameters: queryParams).query}";

                      webViewController.loadUrl(loginUrl, headers: headers);
                    } else {
                      webViewController.loadUrl(url);
                    }
                  },
                  onProgress: (int progress) {
                    avoidPrint("WebView is loading (progress : $progress%)");
                  },
                  navigationDelegate: (NavigationRequest request) {
                    Uri uri = Uri.parse(request.url);
                    String? token = uri.queryParameters['cirilla-token'];
                    if (token != null) {
                      _handleLogin(token);
                    }
                    return _handleNavigate(request.url, items);
                  },
                  onPageStarted: (String url) {
                    avoidPrint('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      _loading = false;
                    });
                  },
                  gestureNavigationEnabled: true,
                ),
                if (_loading) buildLoading(context, isLoading: _loading),
              ],
            )
          : const SizedBox(),
    );
  }

  /// Handle redirect URL
  NavigationDecision _handleNavigate(String url, List<dynamic> items) {
    Map<String, dynamic>? action;

    for (dynamic item in items) {
      Map<String, dynamic>? data = item['data'];
      if (data != null && data['value'] != null && data['value'] != '' && data['condition'] != 'no_condition') {
        if ((data['condition'] == 'url_start' && url.startsWith(data['value'])) ||
            (data['condition'] == 'url_end' && url.endsWith(data['value'])) ||
            (data['condition'] == 'equal_to' && url == data['value']) ||
            (data['condition'] == 'url_contain' && url.contains(data['value']))) {
          action = data['action'];
          break;
        }
      }
    }

    if (action != null) {
      navigate(context, action);
    }

    return NavigationDecision.navigate;
  }

  /// Handle login with param Token
  Future<void> _handleLogin(String token) async {
    try {
      await _authStore.loginByToken(token);
    } catch (e) {
      avoidPrint(e);
    }
  }
}
