import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

abstract class ICellState {
  /// currently selected cell.
  PlutoCell? get currentCell;

  /// currently hovered cell.
  PlutoCell? get hoverCell;

  /// The position index value of the currently selected cell.
  PlutoGridCellPosition? get currentCellPosition;

  /// The position index value of the currently hovered cell.
  PlutoGridCellPosition? get hoverCellPosition;

  PlutoCell? get firstCell;

  void setCurrentCellPosition(
    PlutoGridCellPosition cellPosition, {
    bool notify = true,
  });

  void setHoverCellPosition(
    PlutoGridCellPosition cellPosition, {
    bool notify = true,
  });

  void updateCurrentCellPosition({bool notify = true});

  void updateHoverCellPosition({bool notify = true});

  /// Index position of cell in a column
  PlutoGridCellPosition? cellPositionByCellKey(Key cellKey);

  int? columnIdxByCellKeyAndRowIdx(Key cellKey, int rowIdx);

  /// set currentCell to null
  void clearCurrentCell({bool notify = true});

  /// set hoverCell to null
  void clearHoverCell({bool notify = true});

  /// Change the selected cell.
  void setCurrentCell(
    PlutoCell? cell,
    int? rowIdx, {
    bool notify = true,
  });

  /// Change the selected cell.
  void setHoverCell(
    PlutoCell? cell,
    int? rowIdx, {
    bool notify = true,
  });

  /// Whether it is possible to move in the [direction] from [cellPosition].
  bool canMoveCell(
    PlutoGridCellPosition cellPosition,
    PlutoMoveDirection direction,
  );

  bool canNotMoveCell(
    PlutoGridCellPosition? cellPosition,
    PlutoMoveDirection direction,
  );

  /// Whether the cell is in a mutable state
  bool canChangeCellValue({
    required PlutoCell cell,
    dynamic newValue,
    dynamic oldValue,
  });

  bool canNotChangeCellValue({
    required PlutoCell cell,
    dynamic newValue,
    dynamic oldValue,
  });

  /// Filter on cell value change
  dynamic filteredCellValue({
    required PlutoColumn column,
    dynamic newValue,
    dynamic oldValue,
  });

  /// Whether the cell is the currently hovered cell.
  bool isCurrentCell(PlutoCell cell);

  /// Whether the cell is the currently hovered cell.
  bool isCurrentHoverCell(PlutoCell cell);

  bool isInvalidCellPosition(PlutoGridCellPosition? cellPosition);
}

class _State {
  PlutoCell? _currentCell;

  PlutoCell? _hoverCell;

  PlutoGridCellPosition? _currentCellPosition;

  PlutoGridCellPosition? _hoverCellPosition;
}

mixin CellState implements IPlutoGridState {
  final _State _state = _State();

  @override
  PlutoCell? get currentCell => _state._currentCell;

  @override
  PlutoCell? get hoverCell => _state._hoverCell;

  @override
  PlutoGridCellPosition? get currentCellPosition => _state._currentCellPosition;

  @override
  PlutoGridCellPosition? get hoverCellPosition => _state._hoverCellPosition;

  @override
  PlutoCell? get firstCell {
    if (refRows.isEmpty || refColumns.isEmpty) {
      return null;
    }

    final columnIndexes = columnIndexesByShowFrozen;

    final columnField = refColumns[columnIndexes.first].field;

    return refRows.first.cells[columnField];
  }

  @override
  void setCurrentCellPosition(
    PlutoGridCellPosition? cellPosition, {
    bool notify = true,
  }) {
    if (currentCellPosition == cellPosition) {
      return;
    }

    if (cellPosition == null) {
      clearCurrentCell(notify: false);
    } else if (isInvalidCellPosition(cellPosition)) {
      return;
    }

    _state._currentCellPosition = cellPosition;

    notifyListeners(notify, setCurrentCellPosition.hashCode);
  }

  @override
  void setHoverCellPosition(
    PlutoGridCellPosition? cellPosition, {
    bool notify = true,
  }) {
    if (hoverCellPosition == cellPosition) {
      return;
    }

    if (cellPosition == null) {
      clearHoverCell(notify: false);
    } else if (isInvalidCellPosition(cellPosition)) {
      return;
    }

    _state._hoverCellPosition = cellPosition;

    notifyListeners(notify, setHoverCellPosition.hashCode);
  }

  @override
  void updateCurrentCellPosition({bool notify = true}) {
    if (currentCell == null) {
      return;
    }

    setCurrentCellPosition(
      cellPositionByCellKey(currentCell!.key),
      notify: false,
    );

    notifyListeners(notify, updateCurrentCellPosition.hashCode);
  }

  @override
  void updateHoverCellPosition({bool notify = true}) {
    if (hoverCell == null) {
      return;
    }

    setHoverCellPosition(
      cellPositionByCellKey(hoverCell!.key),
      notify: false,
    );

    notifyListeners(notify, updateHoverCellPosition.hashCode);
  }

  @override
  PlutoGridCellPosition? cellPositionByCellKey(Key? cellKey) {
    if (cellKey == null) {
      return null;
    }

    final length = refRows.length;

    for (int rowIdx = 0; rowIdx < length; rowIdx += 1) {
      final columnIdx = columnIdxByCellKeyAndRowIdx(cellKey, rowIdx);

      if (columnIdx != null) {
        return PlutoGridCellPosition(columnIdx: columnIdx, rowIdx: rowIdx);
      }
    }

    return null;
  }

  @override
  int? columnIdxByCellKeyAndRowIdx(Key cellKey, int rowIdx) {
    if (rowIdx < 0 || rowIdx >= refRows.length) {
      return null;
    }

    final columnIndexes = columnIndexesByShowFrozen;
    final length = columnIndexes.length;

    for (int columnIdx = 0; columnIdx < length; columnIdx += 1) {
      final field = refColumns[columnIndexes[columnIdx]].field;

      if (refRows[rowIdx].cells[field]!.key == cellKey) {
        return columnIdx;
      }
    }

    return null;
  }

  @override
  void clearCurrentCell({bool notify = true}) {
    if (currentCell == null) {
      return;
    }

    _state._currentCell = null;

    _state._currentCellPosition = null;

    notifyListeners(notify, clearCurrentCell.hashCode);
  }

  @override
  void clearHoverCell({bool notify = true}) {
    if (hoverCell == null) {
      return;
    }

    _state._hoverCell = null;

    _state._hoverCellPosition = null;

    notifyListeners(notify, clearHoverCell.hashCode);
  }

  @override
  void setCurrentCell(
    PlutoCell? cell,
    int? rowIdx, {
    bool notify = true,
  }) {
    if (cell == null || rowIdx == null || refRows.isEmpty || rowIdx < 0 || rowIdx > refRows.length - 1) {
      return;
    }

    if (currentCell != null && currentCell!.key == cell.key) {
      return;
    }

    _state._currentCell = cell;

    _state._currentCellPosition = PlutoGridCellPosition(
      rowIdx: rowIdx,
      columnIdx: columnIdxByCellKeyAndRowIdx(cell.key, rowIdx),
    );

    clearCurrentSelecting(notify: false);

    setEditing(autoEditing, notify: false);

    notifyListeners(notify, setCurrentCell.hashCode);
  }

  @override
  void setHoverCell(
    PlutoCell? cell,
    int? rowIdx, {
    bool notify = true,
  }) {
    if (cell == null || rowIdx == null || refRows.isEmpty || rowIdx < 0 || rowIdx > refRows.length - 1) {
      return;
    }

    if (hoverCell != null && hoverCell!.key == cell.key) {
      return;
    }

    _state._hoverCell = cell;

    _state._hoverCellPosition = PlutoGridCellPosition(
      rowIdx: rowIdx,
      columnIdx: columnIdxByCellKeyAndRowIdx(cell.key, rowIdx),
    );

    notifyListeners(notify, setHoverCell.hashCode);
  }

  @override
  bool canMoveCell(
    PlutoGridCellPosition? cellPosition,
    PlutoMoveDirection direction,
  ) {
    if (cellPosition == null || !cellPosition.hasPosition) return false;

    switch (direction) {
      case PlutoMoveDirection.left:
        return cellPosition.columnIdx! > 0;
      case PlutoMoveDirection.right:
        return cellPosition.columnIdx! < refColumns.length - 1;
      case PlutoMoveDirection.up:
        return cellPosition.rowIdx! > 0;
      case PlutoMoveDirection.down:
        return cellPosition.rowIdx! < refRows.length - 1;
    }
  }

  @override
  bool canNotMoveCell(
    PlutoGridCellPosition? cellPosition,
    PlutoMoveDirection direction,
  ) {
    return !canMoveCell(cellPosition, direction);
  }

  @override
  bool canChangeCellValue({
    required PlutoCell cell,
    dynamic newValue,
    dynamic oldValue,
  }) {
    if (!mode.isEditableMode) {
      return false;
    }

    if (cell.column.checkReadOnly(
      cell.row,
      cell.row.cells[cell.column.field]!,
    )) {
      return false;
    }

    if (!isEditableCell(cell)) {
      return false;
    }

    if (newValue.toString() == oldValue.toString()) {
      return false;
    }

    return true;
  }

  @override
  bool canNotChangeCellValue({
    required PlutoCell cell,
    dynamic newValue,
    dynamic oldValue,
  }) {
    return !canChangeCellValue(
      cell: cell,
      newValue: newValue,
      oldValue: oldValue,
    );
  }

  @override
  dynamic filteredCellValue({
    required PlutoColumn column,
    dynamic newValue,
    dynamic oldValue,
  }) {
    if (column.type.isSelect) {
      return column.type.select.items.contains(newValue) == true ? newValue : oldValue;
    }

    if (column.type.isDate) {
      try {
        final parseNewValue = column.type.date.dateFormat.parseStrict(newValue.toString());

        return PlutoDateTimeHelper.isValidRange(
          date: parseNewValue,
          start: column.type.date.startDate,
          end: column.type.date.endDate,
        )
            ? column.type.date.dateFormat.format(parseNewValue)
            : oldValue;
      } catch (e) {
        return oldValue;
      }
    }

    if (column.type.isTime) {
      final time = RegExp(r'^([0-1]?\d|2[0-3]):[0-5]\d$');

      return time.hasMatch(newValue.toString()) ? newValue : oldValue;
    }

    return newValue;
  }

  @override
  bool isCurrentCell(PlutoCell? cell) {
    return currentCell != null && currentCell!.key == cell!.key;
  }

  @override
  bool isCurrentHoverCell(PlutoCell? cell) {
    return hoverCell != null && hoverCell!.key == cell!.key;
  }

  @override
  bool isInvalidCellPosition(PlutoGridCellPosition? cellPosition) {
    return cellPosition == null ||
        cellPosition.columnIdx == null ||
        cellPosition.rowIdx == null ||
        cellPosition.columnIdx! < 0 ||
        cellPosition.rowIdx! < 0 ||
        cellPosition.columnIdx! > refColumns.length - 1 ||
        cellPosition.rowIdx! > refRows.length - 1;
  }
}
