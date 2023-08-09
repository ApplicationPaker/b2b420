import 'package:flutter/material.dart';

// Manual config locale
// ignore: constant_identifier_names
const LANGUAGES = {
  'zh-hant': Locale.fromSubtags(
      languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
  'en': Locale.fromSubtags(languageCode: 'en', countryCode: 'US')
};

// with plugin is [WPML, Polylang]
const multiLanguagePlugin = 'WPML';
