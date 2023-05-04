import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

/// A widget that can be use to determine the size of the wrapped widget
/// Wrap a widget you want to get the size with this Widget
/// it has a [onSizeChange] callback function which will return Size of the widget
/// Useful when you want to determine dynamic size of widget
/// Example:
///   PlutoWidgetSizeDetector(
///     onSizeChange: (Size size) => print(size),
///     child: Container(
///       height: Get.height / 2,
///       child: Text('Example')
///       )
///   )
class PlutoWidgetSizeDetector extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onSizeChange;

  const PlutoWidgetSizeDetector({
    Key? key,
    required this.onSizeChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return WidgetSizeRenderObject(onSizeChange);
  }
}

class WidgetSizeRenderObject extends RenderProxyBox {
  final OnWidgetSizeChange onSizeChange;
  Size? currentSize;

  WidgetSizeRenderObject(this.onSizeChange);

  @override
  void performLayout() {
    super.performLayout();

    try {
      Size? newSize = child?.size;

      if (newSize != null && currentSize != newSize) {
        currentSize = newSize;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onSizeChange(newSize);
        });
      }
    } catch (_) {}
  }
}
