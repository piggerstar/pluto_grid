import 'package:flutter/material.dart';

class PlutoScaledCheckbox extends StatelessWidget {
  final bool? value;

  final Function(bool? changed) handleOnChanged;

  final bool tristate;

  final double scale;

  final Color unselectedColor;

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

  final MaterialTapTargetSize? materialTapTargetSize;

  final ThemeData? themeData;

  const PlutoScaledCheckbox({
    Key? key,
    required this.value,
    required this.handleOnChanged,
    this.tristate = false,
    this.scale = 1.0,
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
    this.materialTapTargetSize,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Transform.scale(
      scale: scale,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: unselectedColor,
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
          side: side,
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
