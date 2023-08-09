import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CirillaQuantity extends StatefulWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final double width;
  final double height;
  final Color? color;
  final Color? borderColor;
  final int min;
  final int? max;
  final Function? actionZero;
  final double? radius;
  final TextStyle? textStyle;

  const CirillaQuantity({
    Key? key,
    required this.value,
    required this.onChanged,
    this.height = 34,
    this.width = 90,
    this.color,
    this.min = 1,
    this.max,
    this.actionZero,
    this.radius,
    this.borderColor,
    this.textStyle,
  })  : assert(height >= 28),
        assert(width >= 64),
        assert(max == null || max >= min),
        super(key: key);

  @override
  State<CirillaQuantity> createState() => _CirillaQuantityState();
}

class _CirillaQuantityState extends State<CirillaQuantity> with ShapeMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    int qty = widget.value;
    _controller = TextEditingController(text: qty.toString());

    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        _controller.text = widget.min.toString();
      } else {
        int qty = getQty(_controller.text);
        if (_controller.text != qty.toString()) {
          _controller.text = qty.toString();
        }
        if (widget.value != qty) {
          widget.onChanged?.call(qty);
        }
      }
    });
    super.initState();
  }

  int getQty(String text) {
    int qty = ConvertData.stringToInt(text, widget.min);
    if (numberValidator(value: text, errorNumber: 'error') == 'error' || qty < widget.min) {
      qty = widget.min;
    } else {
      if (widget.max != null && qty > widget.max!) {
        qty = widget.max!;
      }
    }
    return qty;
  }

  void onChange(dynamic value) {
    int qty = ConvertData.stringToInt(value, widget.min);
    if (qty < widget.min) qty = widget.min;
    if (widget.max != null && qty > widget.max!) qty = widget.max!;
    _controller.text = qty.toString();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double heightItem = widget.height;
    TextStyle textStyle =
        theme.textTheme.bodyMedium!.copyWith(color: theme.textTheme.titleMedium!.color).merge(widget.textStyle);
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.radius ?? 4),
        border: widget.borderColor != null ? Border.all(color: widget.borderColor!) : null,
      ),
      height: heightItem,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          buildIconButton(
            icon: Icons.remove_rounded,
            theme: theme,
            onTap: widget.value > widget.min ? () => onChange(widget.value - 1) : null,
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.min.toString(),
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: textStyle,
            ),
          ),
          buildIconButton(
            icon: Icons.add_rounded,
            theme: theme,
            onTap: widget.max == null || (widget.max != null && widget.max! > widget.value)
                ? () => onChange(widget.value + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    GestureTapCallback? onTap,
    required ThemeData theme,
  }) {
    Widget child = Container(
      height: double.infinity,
      width: 32,
      padding: paddingHorizontalTiny,
      child: Icon(
        icon,
        size: 16,
        color: onTap != null ? theme.textTheme.titleMedium!.color : theme.textTheme.bodyMedium?.color,
      ),
    );
    return onTap != null
        ? InkWell(
            onTap: onTap,
            child: child,
          )
        : child;
  }
}
