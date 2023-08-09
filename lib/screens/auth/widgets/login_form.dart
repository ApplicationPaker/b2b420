import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/screens/auth/forgot_screen.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_captcha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final HandleLoginType? handleLogin;

  const LoginForm({Key? key, this.handleLogin}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with Utility {
  final _formKey = GlobalKey<FormState>();
  final _txtUsernameOrEmail = TextEditingController();
  final _txtPassword = TextEditingController();

  bool _obscureText = true;
  FocusNode? _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _txtUsernameOrEmail.dispose();
    _txtPassword.dispose();
    _passwordFocusNode!.dispose();
    super.dispose();
  }

  void _updateObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _handleForgot() {
    Navigator.of(context).pushNamed(ForgotScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    Map<String, dynamic>? data = settingStore.data?.settings!['general']!.widgets!['general']!.fields;

    bool enableCaptchaLogin = get(data, ['enableCaptchaLogin'], true);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUsernameOrEmailField(translate),
          const SizedBox(height: 16),
          buildPasswordField(translate),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: _handleForgot,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: textTheme.bodySmall,
              ),
              child: Text(translate('login_btn_forgot_password')),
            ),
          ),
          const SizedBox(height: 24),
          CirillaCaptchaWrap(
            enable: enableCaptchaLogin,
            submit: (captcha, phrase) => widget.handleLogin!({
              'username': _txtUsernameOrEmail.text,
              'password': _txtPassword.text,
              'captcha': captcha,
              'phrase': phrase,
            }),
            buildButton: (onPressed) {
              return SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onPressed();
                    }
                  },
                  child: Text(translate('login_btn_login')),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildUsernameOrEmailField(TranslateType translate) {
    return TextFormField(
      controller: _txtUsernameOrEmail,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_user_email_required');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translate('input_user_email'),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  Widget buildPasswordField(TranslateType translate) {
    return TextFormField(
      controller: _txtPassword,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_password_required');
        }
        return null;
      },
      focusNode: _passwordFocusNode,
      obscureText: _obscureText, // Error when login then login again if enable
      decoration: InputDecoration(
        labelText: translate('input_password'),
        suffixIcon: IconButton(
          iconSize: 16,
          icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: _updateObscure,
        ),
      ),
    );
  }
}
