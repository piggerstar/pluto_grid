import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid/src/helper/platform_helper.dart';

abstract class TextCell extends StatefulWidget {
  final PlutoGridStateManager stateManager;

  final PlutoCell cell;

  final PlutoColumn column;

  final PlutoRow row;

  const TextCell({
    required this.stateManager,
    required this.cell,
    required this.column,
    required this.row,
    Key? key,
  }) : super(key: key);
}

abstract class TextFieldProps {
  TextInputType get keyboardType;

  List<TextInputFormatter>? get inputFormatters;
}

mixin TextCellState<T extends TextCell> on State<T> implements TextFieldProps {
  dynamic _initialCellValue;

  final textController = TextEditingController();

  final PlutoDebounceByHashCode _debounce = PlutoDebounceByHashCode();

  late final FocusNode cellFocus;

  late CellEditingStatus _cellEditingStatus;

  @override
  TextInputType get keyboardType => TextInputType.text;

  @override
  List<TextInputFormatter>? get inputFormatters => [];

  /// override default column configuration if the row has its own column configuration
  PlutoColumn get column => widget.column;

  String get formattedValue => column.formattedValueForDisplayInEditing(widget.cell.value);

  @override
  void initState() {
    super.initState();
    cellFocus = FocusNode(onKey: _handleOnKey);

    textController.text = formattedValue;
    _initialCellValue = textController.text;
    _cellEditingStatus = CellEditingStatus.init;

    cellFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    /**
     * Saves the changed value when moving a cell while text is being input.
     * if user do not press enter key, onEditingComplete is not called and the value is not saved.
     */
    if (_cellEditingStatus.isChanged) {
      _changeValue();
    }

    /**
     * Always trigger cell changed when the cell is disposed
     */
    _triggerCellChanged();

    if (!widget.stateManager.isEditing || widget.stateManager.currentColumn?.enableEditingMode != true) {
      widget.stateManager.setTextEditingController(null);
    }

    _debounce.dispose();

    textController.dispose();

    cellFocus.removeListener(_onFocusChange);
    cellFocus.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    if (!cellFocus.hasFocus) {
      widget.stateManager.setEditing(false, notify: !column.keepFocusOnChange);

      if (column.keepFocusOnChange) {
        widget.stateManager.setKeepFocus(true);
      }
    } else if (_cellEditingStatus.isChanged) {
      _changeValue(notify: false);
    }
  }

  void _restoreText() {
    if (_cellEditingStatus.isNotChanged) {
      return;
    }

    textController.text = _initialCellValue.toString();

    widget.stateManager.changeCellValue(
      widget.stateManager.currentCell!,
      _initialCellValue,
      notify: false,
      status: _cellEditingStatus,
    );
  }

  bool _moveHorizontal(PlutoKeyManagerEvent keyManager) {
    if (!keyManager.isHorizontal) {
      return false;
    }

    if (column.readOnly == true) {
      return true;
    }

    final selection = textController.selection;

    if (selection.baseOffset != selection.extentOffset) {
      return false;
    }

    if (selection.baseOffset == 0 && keyManager.isLeft) {
      return true;
    }

    final textLength = textController.text.length;

    if (selection.baseOffset == textLength && keyManager.isRight) {
      return true;
    }

    return false;
  }

  void _triggerCellChanged({bool notify = true}) {
    widget.stateManager.notifyOnCellChange(widget.cell, textController.text, status: _cellEditingStatus, notify: notify);
  }

  void _changeValue({bool notify = true}) {
    if (formattedValue == textController.text || !widget.cell.enabled) {
      return;
    }

    widget.stateManager.changeCellValue(widget.cell, textController.text, status: _cellEditingStatus, notify: notify);

    textController.text = formattedValue;

    _initialCellValue = textController.text;

    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

    _cellEditingStatus = CellEditingStatus.updated;
  }

  void handleOnChanged(String value) {
    _cellEditingStatus = formattedValue != value.toString()
        ? CellEditingStatus.changed
        : _initialCellValue.toString() == value.toString()
            ? CellEditingStatus.init
            : CellEditingStatus.updated;
  }

  void _handleOnComplete() {
    final old = textController.text;

    _changeValue();

    handleOnChanged(old);

    PlatformHelper.onMobile(() {
      widget.stateManager.setKeepFocus(false);
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  KeyEventResult _handleOnKey(FocusNode node, RawKeyEvent event) {
    if (!widget.cell.enabled) {
      return KeyEventResult.ignored;
    }

    var keyManager = PlutoKeyManagerEvent(
      focusNode: node,
      event: event,
    );

    if (keyManager.isKeyUpEvent) {
      return KeyEventResult.handled;
    }

    final skip = !(keyManager.isVertical || _moveHorizontal(keyManager) || keyManager.isEsc || keyManager.isTab || keyManager.isF3 || keyManager.isEnter);

    // 이동 및 엔터키, 수정불가 셀의 좌우 이동을 제외한 문자열 입력 등의 키 입력은 텍스트 필드로 전파 한다.
    if (skip) {
      return widget.stateManager.keyManager!.eventResult.skip(
        KeyEventResult.ignored,
      );
    }

    if (_debounce.isDebounced(
      hashCode: textController.text.hashCode,
      ignore: !kIsWeb,
    )) {
      return KeyEventResult.handled;
    }

    // 엔터키는 그리드 포커스 핸들러로 전파 한다.
    if (keyManager.isEnter) {
      _handleOnComplete();
      return KeyEventResult.ignored;
    }

    // ESC 는 편집된 문자열을 원래 문자열로 돌이킨다.
    if (keyManager.isEsc) {
      _restoreText();
    }

    // KeyManager 로 이벤트 처리를 위임 한다.
    widget.stateManager.keyManager!.subject.add(keyManager);

    // 모든 이벤트를 처리 하고 이벤트 전파를 중단한다.
    return KeyEventResult.handled;
  }

  void _handleOnTap() {
    widget.stateManager.setKeepFocus(true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stateManager.keepFocus) {
      cellFocus.requestFocus();
    }

    return Container(
      padding: column.type.textInputPadding,
      child: TextField(
        focusNode: cellFocus,
        enabled: widget.cell.enabled,
        controller: textController,
        readOnly: column.checkReadOnly(widget.row, widget.cell),
        onChanged: handleOnChanged,
        onEditingComplete: _handleOnComplete,
        onSubmitted: (_) => _handleOnComplete(),
        onTap: _handleOnTap,
        expands: column.type.textInputExpands,
        style: widget.stateManager.configuration.style.cellTextStyle,
        decoration: column.type.textInputDecoration ??
            (widget.stateManager.configuration.style.cellTextInputDecoration ??
                const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                )),
        maxLines: column.type.textInputExpands ? null : column.type.textInputMaxLines,
        buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: column.maxLength,
        maxLengthEnforcement: column.maxLengthEnforcement,
        textAlignVertical: TextAlignVertical.center,
        textAlign: column.textAlign.value,
      ),
    );
  }
}

enum CellEditingStatus {
  init,
  changed,
  updated;

  bool get isNotChanged {
    return CellEditingStatus.changed != this;
  }

  bool get isChanged {
    return CellEditingStatus.changed == this;
  }

  bool get isUpdated {
    return CellEditingStatus.updated == this;
  }
}
