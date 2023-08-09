import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';

class FieldSwitch extends StatelessWidget with Utility {
  final dynamic value;
  final String? align;
  final Color? color;

  const FieldSwitch({
    Key? key,
    this.value,
    this.align,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextAlign textAlign = align == 'center'
        ? TextAlign.center
        : align == 'right'
            ? TextAlign.end
            : TextAlign.start;
    bool valueSwitch = value is bool ? value : false;
    return Text('$valueSwitch', textAlign: textAlign, style: TextStyle(color: color));
  }
}
