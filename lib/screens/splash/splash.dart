import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/painter/zoom_painter.dart';

import '../../store/auth/auth_store.dart';
import '../../types/types.dart';
import '../../utils/shared_preferences_auth.dart';
import 'widgets/zoom_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.color, this.loading}) : super(key: key);

  final Color? color;
  final bool? loading;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  late AnimationController _controller;
  late ZoomAnimation _animation;
  AnimationStatus _status = AnimationStatus.forward;

  AuthStore? _authStore;
  PrefUtils userprefs = PrefUtils();

  void _handleLogin(Map<String, dynamic> queryParameters) async {
    try {
      ModalRoute? modalRoute = ModalRoute.of(context);
      await _authStore!.loginStore.login(queryParameters);
      final Map<String, dynamic> args =
          modalRoute!.settings.arguments as Map<String, dynamic>;
      ShowMessageType? showMessage = args['showMessage'];
      if (showMessage != null) {
        showMessage(message: 'Logged!');
        userprefs.username = queryParameters['username'];
        userprefs.password = queryParameters['password'];
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      //  showError(context, e, onLinkTap: _onLinkTab);
    }
  }

  @override
  void initState() {
    super.initState();
    userprefs.init().then((value) {
      if (userprefs.username != '' && userprefs.password != '') {
        _handleLogin({
          'username': userprefs.username,
          'password': userprefs.password,
          'captcha': '',
          'phrase': ''
        });
      }
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )
      ..addStatusListener((AnimationStatus status) {
        setState(() {
          _status = status;
        });
      })
      ..addListener(() {
        setState(() {});
      });
    _animation = ZoomAnimation(_controller);
  }

  @override
  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
    _authStore ??= Provider.of<AuthStore>(context);
  }

  @override
  void didUpdateWidget(covariant SplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.loading! && _controller.status != AnimationStatus.forward) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status == AnimationStatus.completed) return Container();

    return Stack(children: [
      SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: ZoomPainter(
              color: widget.color!,
              zoomSize: _animation.zoomSize.value * size.width),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: itemPaddingExtraLarge),
        child: Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: _animation.textOpacity.value,
            child: Image.asset(Assets.splash, fit: BoxFit.cover),
          ),
        ),
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
