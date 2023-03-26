import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'text_cell.dart';

class PlutoTextCell extends StatefulWidget implements TextCell {
  @override
  final PlutoGridStateManager stateManager;

  @override
  final PlutoCell cell;

  @override
  final PlutoColumn column;

  @override
  final PlutoRow row;

  const PlutoTextCell({
    required this.stateManager,
    required this.cell,
    required this.column,
    required this.row,
    Key? key,
  }) : super(key: key);

  @override
  PlutoTextCellState createState() => PlutoTextCellState();
}

class PlutoTextCellState extends State<PlutoTextCell> with TextCellState<PlutoTextCell> {
  @override
  late final List<TextInputFormatter>? inputFormatters;

  @override
  void initState() {
    super.initState();
    final textColumn = column.type.text;
    inputFormatters = textColumn.inputFormatters;

    widget.stateManager.setInputFormatters(inputFormatters);
    widget.stateManager.setTextEditingController(textController);
    textController.addListener(() {
      handleOnChanged(textController.text.toString());
    });
  }
}
