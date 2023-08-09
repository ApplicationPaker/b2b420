import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable()
class Setting {
  @JsonKey(name: 'plugin_name')
  String? pluginName;

  String? language;

  @JsonKey(toJson: dataToJson)
  DataScreen? data;

  Setting({
    this.pluginName,
    this.language,
    this.data,
  });

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);

  Map<String, dynamic> toJson() => _$SettingToJson(this);

  static dataToJson(DataScreen? data) => data?.toJson();
}

@JsonSerializable()
class DataScreen {
  @JsonKey(toJson: dataToJson)
  Map<String, Data>? screens;

  @JsonKey(toJson: dataToJson)
  Map<String, Data>? settings;

  @JsonKey(toJson: dataToJson)
  Map<String, Data>? extraScreens;

  DataScreen({
    this.screens,
    this.settings,
    this.extraScreens,
  });

  factory DataScreen.fromJson(Map<String, dynamic> json) =>
      _$DataScreenFromJson(json);

  Map<String, dynamic> toJson() => _$DataScreenToJson(this);

  static Map<String, dynamic> dataToJson(Map<String, Data>? json) {
    if (json == null) return {};
    final result = Map.fromEntries(
        json.keys.map((key) => MapEntry(key, json[key]!.toJson())));
    return result;
  }
}

@JsonSerializable()
class Data {
  @JsonKey(toJson: dataToJson)
  Map<String, WidgetConfig>? widgets;

  @JsonKey(fromJson: _fromIds)
  List<String>? widgetIds;

  @JsonKey(defaultValue: {})
  Map<String, dynamic>? configs;

    Data({
    required this.widgets,
    required this.widgetIds,
    required this.configs
  });


  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  static Map<String, dynamic> dataToJson(Map<String, WidgetConfig>? json) {
    if (json == null) return {};

    final result = Map.fromEntries(
        json.keys.map((key) => MapEntry(key, json[key]!.toJson())));
    return result;
  }

  static List<String> _fromIds(List<dynamic>? ids) {
    if (ids == null) return [];
    List<String> newIds = ids.whereType<String>().toList();
    return newIds;
  }
  Data copyWith({
    Map<String,WidgetConfig>? widgets,
    List<String>? widgetIds,
    Map<String,dynamic>? configs
  }) {
    return Data(
          widgets: widgets ?? this.widgets,
      widgetIds: widgetIds ?? this.widgetIds,
      configs: configs ?? this.configs
    );
  }
}

@JsonSerializable()
class   WidgetConfig {
  String? id;

  String? type;

  @JsonKey(fromJson: _fromMap)
  Map<String, dynamic>? fields;

  @JsonKey(fromJson: _fromMap)
  Map<String, dynamic>? styles;

  String? layout;

  WidgetConfig(
      {required this.fields,
      required this.styles,
      this.id,
      this.type,
      this.layout});

  factory WidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetConfigToJson(this);

  static Map<String, dynamic>? _fromMap(dynamic value) {
    if (value is Map<String, dynamic>?) {
      return value;
    }
    return {};
  }

  WidgetConfig copyWith(
      {ValueGetter<String?>? id,
      ValueGetter<String?>? type,
      Map<String, WidgetConfig>? fields,
      Map<String, dynamic>? styles,
      ValueGetter<String?>? layout}) {
    return WidgetConfig(
        id: id != null ? id() : this.id,
        type: type != null ? type() : this.type,
        fields: fields ?? this.fields,
        styles: styles ?? this.styles,
        layout: layout != null ? layout() : this.layout);
  }
}
