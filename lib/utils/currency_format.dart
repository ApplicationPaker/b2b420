import 'dart:math';

import 'package:cirilla/constants/app.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'convert_data.dart';
import 'package:cirilla/models/currency/currency.dart' show getCurrencies;

///
/// Format currency
///
String formatCurrency(BuildContext context, {String? price, String? currency, String? symbol, String? pattern}) {
  // Return empty price
  if (price == null || price.isEmpty || price == "") {
    return "";
  }

  SettingStore settingStore = Provider.of<SettingStore>(context);
  String? newCurrency = currency ?? settingStore.currency;

  Map<String, dynamic>? newCurrencyInfo;
  if (settingStore.currencies.containsKey(newCurrency)) {
    newCurrencyInfo = settingStore.currencies[settingStore.currency!];
  } else {
    newCurrencyInfo = getCurrencies[newCurrency];
  }

  int numDecimals = ConvertData.stringToInt(get(newCurrencyInfo, ['num_decimals'], 2));
  String? newSymbol = symbol ?? get(newCurrencyInfo, ['symbol'], '\$');

  NumberFormat f = NumberFormat.currency(
    locale: NumberFormat.localeExists(settingStore.locale) ? settingStore.locale : defaultLanguage,
    symbol: newSymbol,
    decimalDigits: numDecimals,
  );
  return f.format(ConvertData.stringToDouble(price));
}

///
/// Convert currency
///
String? convertCurrency(BuildContext context, {String? price, String? currency, int? unit}) {
  if (currency == null) {
    return price;
  }

  int u = unit != null && unit > 0 ? pow(10, unit) as int : 1;
  double currencyPrice = ConvertData.stringToDouble(price) / u;

  // Get currency info
  SettingStore settingStore = Provider.of<SettingStore>(context);

  // Format if it is default currency
  if (settingStore.currency == currency) {
    return formatCurrency(context, price: currencyPrice.toString());
  }

  Map<String, dynamic> newCurrencyInfo = settingStore.currencies[settingStore.currency!];

  // Calc rate currency
  double priceRate = ConvertData.stringToDouble(newCurrencyInfo['rate']) * currencyPrice;

  return formatCurrency(context, price: priceRate.toString());
}

String convertCurrencyFromUnit({String? price, int? unit}){
  int u = unit != null && unit > 0 ? pow(10, unit) as int : 1;
  String currencyPrice = (ConvertData.stringToDouble(price) / u).toString();
  return currencyPrice;
}
