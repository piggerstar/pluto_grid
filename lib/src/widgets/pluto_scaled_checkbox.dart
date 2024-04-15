import 'package:flutter/material.dart';

class PlutoScaledCheckbox extends StatelessWidget {
  final bool? value;

  final Function(bool? changed) handleOnChanged;

  final bool tristate;

  final double scale;

  final Color unselectedColor;

  final Color disabledColor;

  final Color? activeColor;

  final Color checkColor;

  final bool enabled;

  final String? tooltipMessage;

  final TextStyle? tooltipTextStyle;

  final BoxDecoration? tooltipBoxDecoration;

  final Color? hoverColor;

  final Color? focusColor;

  final MouseCursor? mouseCursor;

  final MaterialStateProperty<Color?>? fillColor;

  final MaterialStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final OutlinedBorder? shape;

  final BorderSide? side;

  final BorderSide? disabledSide;

  final MaterialTapTargetSize? materialTapTargetSize;

  final ThemeData? themeData;

  final Color? disabledBackgroundColor;

  final EdgeInsets? margin;

  const PlutoScaledCheckbox({
    super.key,
    required this.value,
    required this.handleOnChanged,
    this.tristate = false,
    this.scale = 1.0,
    this.disabledColor = const Color(0xFF9E9E9E),
    this.unselectedColor = Colors.black26,
    this.activeColor = Colors.lightBlue,
    this.checkColor = const Color(0xFFDCF5FF),
    this.enabled = true,
    this.tooltipMessage,
    this.tooltipTextStyle,
    this.tooltipBoxDecoration,
    this.hoverColor,
    this.focusColor,
    this.mouseCursor,
    this.fillColor,
    this.overlayColor,
    this.splashRadius,
    this.shape,
    this.side,
    this.disabledSide,
    this.materialTapTargetSize,
    this.themeData,
    this.disabledBackgroundColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Transform.scale(
      scale: scale,
      child: Container(
        height: 18.0,
        width: 18.0,
        color: enabled ? null : disabledBackgroundColor,
        margin: margin ?? const EdgeInsets.all(8),
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: enabled ? unselectedColor : disabledColor,
            disabledColor: disabledColor,
          ),
          child: Checkbox(
            value: enabled ? value : false,
            tristate: tristate,
            onChanged: enabled ? handleOnChanged : null,
            activeColor: value == null ? unselectedColor : activeColor,
            checkColor: checkColor,
            materialTapTargetSize: materialTapTargetSize,
            fillColor: fillColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            mouseCursor: mouseCursor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            shape: shape,
            side: enabled ? side : disabledSide,
          ),
        ),
      ),
    );

    if (!enabled) {
      child = IgnorePointer(child: child);
    }

    if (tooltipMessage != null) {
      child = Tooltip(
        textStyle: tooltipTextStyle ?? const TextStyle(color: Color(0xFF4A4A4A), fontSize: 12, height: 1.2),
        decoration: tooltipBoxDecoration ??
            BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFCCDFFF)),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
        message: tooltipMessage!,
        child: child,
      );
    }

    return child;
  }
}
