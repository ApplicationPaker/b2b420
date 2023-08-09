//ignore: unused_import
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    if (kDebugMode) {
      print('SharedPreference Initialized');
    }
  }

  set username(String value) {
    _sharedPreferences!.setString('loginemail', value);
  }

  String get username {
    return _sharedPreferences!.getString('loginemail') ?? '';
  }

  set password(String value) {
    _sharedPreferences!.setString('loginpassword', value);
  }

  String get password {
    return _sharedPreferences!.getString('loginpassword') ?? '';
  }

  set rememberusername(String value) {
    _sharedPreferences!.setString('rememberloginemail', value);
  }

  set token(String value) {
    _sharedPreferences!.setString('token', value);
  }

  String get token {
    return _sharedPreferences!.getString('token') ?? '';
  }

  String get rememberusername {
    return _sharedPreferences!.getString('rememberloginemail') ?? '';
  }

  set rememberpassword(String value) {
    _sharedPreferences!.setString('rememberpassword', value);
  }

  String get rememberpassword {
    return _sharedPreferences!.getString('rememberpassword') ?? '';
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }
}
