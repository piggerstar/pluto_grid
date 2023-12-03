import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// columnGroups that can group columns can be omitted.
final List<PlutoColumnGroup> defaultColumnGroups = [
  PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
  PlutoColumnGroup(title: 'User information', fields: ['name', 'age']),
  PlutoColumnGroup(title: 'Status', children: [
    PlutoColumnGroup(title: 'A', fields: ['role'], expandedColumn: true),
    PlutoColumnGroup(title: 'Etc.', fields: ['joined', 'working_time']),
  ]),
];

final List<PlutoColumn> defaultColumns = <PlutoColumn>[
  PlutoColumn(
    title: 'Id',
    field: 'id',
    type: PlutoColumnType.text(),
    enableRowChecked: true,
    keepFocusOnChange: true,
    enableColumnDrag: false,
    enableRowDrag: false,
    enableContextMenu: false,
    enableDropToResize: false,
    enableEditingMode: false,
    enableAutoEditing: false,
    enableSorting: false,
    frozen: PlutoColumnFrozen.start,
    percentage: 0.2,
    checkboxFillColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.red;
      }
      if (states.contains(MaterialState.hovered)) {
        return Colors.blue;
      }
      if (states.contains(MaterialState.disabled)) {
        return Colors.white10;
      }
      return Colors.green;
    }),
    renderer: (rendererContext) {
      return Container(
        alignment: Alignment.centerRight,
        child: Text(rendererContext.cell.value.toString()),
      );
    },
  ),
  PlutoColumn(
    title: 'Name',
    field: 'name',
    type: PlutoColumnType.text(),
    percentage: 0.2,
  ),
  PlutoColumn(
    title: 'Age',
    field: 'age',
    type: PlutoColumnType.number(),
    maxLength: 3,
    enableAutoEditing: false,
    percentage: 0.1,
  ),
  PlutoColumn(
    title: 'Role',
    field: 'role',
    type: PlutoColumnType.select(<String>[
      'Programmer',
      'Designer',
      'Owner',
    ]),
    percentage: 0.1,
  ),
  PlutoColumn(
    title: 'Joined',
    field: 'joined',
    type: PlutoColumnType.date(),
    percentage: 0.1,
  ),
  PlutoColumn(
    title: 'Working time',
    field: 'working_time',
    type: PlutoColumnType.time(),
    percentage: 0.1,
  ),
  PlutoColumn(
    title: 'salary',
    field: 'salary',
    type: PlutoColumnType.currency(),
    percentage: 0.2,
    frozen: PlutoColumnFrozen.end,
    footerRenderer: (rendererContext) {
      return PlutoAggregateColumnFooter(
        rendererContext: rendererContext,
        formatAsCurrency: true,
        type: PlutoAggregateColumnType.sum,
        format: '#,###',
        alignment: Alignment.center,
        titleSpanBuilder: (text) {
          return [
            const TextSpan(
              text: 'Sum',
              style: TextStyle(color: Colors.red),
            ),
            const TextSpan(text: ' : '),
            TextSpan(text: text),
          ];
        },
      );
    },
  ),
];

final List<PlutoColumn> simpleColumns = <PlutoColumn>[
  PlutoColumn(
    title: 'Id',
    field: 'id',
    type: PlutoColumnType.text(),
    percentage: 0.1,
    enableRowChecked: true,
    keepFocusOnChange: true,
    enableColumnDrag: false,
    enableRowDrag: false,
    enableContextMenu: false,
    enableDropToResize: true,
    enableEditingMode: false,
    enableAutoEditing: false,
    enableSorting: false,
    frozen: PlutoColumnFrozen.start,
    suppressedAutoSize: true,
    checkboxTooltipMessage: 'This is a checkbox tooltip.',
    checkboxThemeData: ThemeData(
      disabledColor: const Color(0xFFF4F4F4),
    ),
    checkboxUnselectedColor: Colors.green,
  ),
  PlutoColumn(
    title: 'Name',
    field: 'name',
    width: 180,
    minWidth: 180,
    readOnly: true,
    cellPadding: EdgeInsets.zero,
    renderer: (context) {
      return Column(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Container(height: 80, decoration: BoxDecoration(border: Border.all(color: Colors.black45)), child: Center(child: Text(context.cell.value)))),
                Expanded(child: Container(height: 80, decoration: BoxDecoration(border: Border.all(color: Colors.black45)), child: Center(child: Text(context.cell.value)))),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Container(height: 80, decoration: BoxDecoration(border: Border.all(color: Colors.black45)), child: Center(child: Text(context.cell.value)))),
                Expanded(child: Container(height: 80, decoration: BoxDecoration(border: Border.all(color: Colors.black45)), child: Center(child: Text(context.cell.value)))),
              ],
            ),
          ),
        ],
      );
    },
    type: PlutoColumnType.text(
      padding: const EdgeInsets.symmetric(vertical: 6),
      inputDecoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Color(0xFFCCDFFF))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Color(0xFFCCDFFF))),
      ),
    ),
  ),
  PlutoColumn(
    title: 'Amount',
    field: 'amount',
    type: PlutoColumnType.currency(format: '#,###.##', negative: false),
  ),
  PlutoColumn(
    title: 'Age',
    field: 'age',
    type: PlutoColumnType.number(
      defaultValue: null,
      allowEmpty: true,
    ),
    maxLength: 3,
    enableDropToResize: false,
    showContextIcon: false,
    enableEditingMode: true,
    enableAutoEditing: false,
    checkReadOnly: (row, cell) {
      if (row.cells['id']?.value == 'user1') {
        return true;
      }
      return false;
    },
  ),
  PlutoColumn(
    title: 'Role',
    field: 'role',
    type: PlutoColumnType.select(<String>[
      'Programmer',
      'Designer',
      'Owner',
    ]),
  ),
  PlutoColumn(
    title: 'Joined',
    field: 'joined',
    type: PlutoColumnType.date(),
  ),
  PlutoColumn(
    title: 'Working time',
    field: 'working_time',
    type: PlutoColumnType.time(),
    frozen: PlutoColumnFrozen.end,
  ),
];

final List<PlutoRow> rows = [
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user1'),
      'name': PlutoCell(value: 'Mike', enabled: false),
      'amount': PlutoCell(value: 10),
      'age': PlutoCell(value: 20, enabled: false),
      'role': PlutoCell(value: 'Programmer'),
      'joined': PlutoCell(value: '2021-01-01'),
      'working_time': PlutoCell(value: '09:00'),
      'salary': PlutoCell(value: 300),
    },
  ),
];
