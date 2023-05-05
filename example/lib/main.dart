import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlutoGrid Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlutoGridExamplePage(),
    );
  }
}

/// PlutoGrid Example
//
/// For more examples, go to the demo web link on the github below.
class PlutoGridExamplePage extends StatefulWidget {
  const PlutoGridExamplePage({Key? key}) : super(key: key);

  @override
  State<PlutoGridExamplePage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<PlutoGridExamplePage> {
  final GlobalKey _footerKey = GlobalKey();
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
      enableRowChecked: true,
      keepFocusOnChange: true,
      frozen: PlutoColumnFrozen.start,
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.start,
    ),
    PlutoColumn(
      title: 'Amount',
      field: 'amount',
      type: PlutoColumnType.currency(format: '#,###.##', negative: false),
      frozen: PlutoColumnFrozen.start,
    ),
    PlutoColumn(
      title: 'Age',
      field: 'age',
      type: PlutoColumnType.number(),
      maxLength: 3,
      enableAutoEditing: false,
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
    ),
    PlutoColumn(
      title: 'salary',
      field: 'salary',
      type: PlutoColumnType.currency(),
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
      enableRowChecked: true,
      keepFocusOnChange: true,
      frozen: PlutoColumnFrozen.start,
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      width: 120,
      minWidth: 120,
      renderer: (context) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCCDFFF)), borderRadius: BorderRadius.circular(5)),
          child: Text(context.cell.value),
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
      type: PlutoColumnType.number(),
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
      // footerRenderer: (rendererContext) {
      //   return PlutoAggregateColumnFooter(
      //     rendererContext: rendererContext,
      //     type: PlutoAggregateColumnType.count,
      //     alignment: Alignment.center,
      //     titleSpanBuilder: (text) {
      //       return [
      //         const TextSpan(
      //           text: 'Count',
      //           style: TextStyle(color: Colors.red),
      //         ),
      //         const TextSpan(text: ' : '),
      //         TextSpan(text: text),
      //       ];
      //     },
      //   );
      // },
    ),
  ];

  final List<PlutoRow> emptyRows = [];

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

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'User information', fields: ['name', 'age']),
    PlutoColumnGroup(title: 'Status', children: [
      PlutoColumnGroup(title: 'A', fields: ['role'], expandedColumn: true),
      PlutoColumnGroup(title: 'Etc.', fields: ['joined', 'working_time']),
    ]),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  PlutoGridStateManager? stateManager;
  final ScrollController controller = ScrollController();

  List<PlutoRow> get getRows => List.generate(0, (index) => rows[0]);

  List<PlutoColumn> get getColumns => simpleColumns;

  List<PlutoColumnGroup>? get getColumnGroups => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton(
              onPressed: () {
                stateManager!.toggleCheckboxViewColumn(stateManager!.columns.first, !stateManager!.columns.first.enableRowChecked);
              },
              child: const Text('Hide/Un-Hide Column Checkbox'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Default Table Height: ${stateManager?.defaultTableHeight}\nTable Height: ${stateManager?.tableHeight}'),
            ),
            Center(
              child: PlutoGrid(
                autoSize: true,
                scrollController: controller,
                columns: getColumns,
                rows: getRows,
                columnGroups: getColumnGroups,
                autoSizeHeightOffset: (stateManager?.refRows.isEmpty ?? true) ? 180 : 0,
                noRowsWidget: Container(height: 50, color: Colors.lightBlueAccent, child: const Text('No data.')),
                useCustomFooter: false,
                showTableLoadingText: false,
                customTableLoading: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [CircularProgressIndicator()],
                    ),
                  ),
                ),
                onLoaded: (PlutoGridOnLoadedEvent event) async {
                  stateManager = event.stateManager;
                  await _insertRow();
                  stateManager!.autoFitAllColumn(context, force: true);
                  setState(() {});
                },
                onChanged: (PlutoGridOnChangedEvent event) {
                  print('onChanged $event');
                },
                onCellChanged: (PlutoGridOnChangedEvent event) {
                  print('onCellChanged $event');
                },
                configuration: const PlutoGridConfiguration(
                  scrollbar: PlutoGridScrollbarConfig(isAlwaysShown: false),
                  style: PlutoGridStyleConfig(
                    activatedColor: Colors.white,
                    gridBorderColor: Colors.green,
                    borderColor: Colors.lightBlueAccent,
                    rowHeight: 46,
                    columnHeight: 46,
                  ),
                ),
                createFooter: (v) {
                  return StatefulBuilder(
                    key: _footerKey,
                    builder: (context, setState) {
                      return SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (stateManager?.showLoading ?? false) const CircularProgressIndicator(),
                              if (!(stateManager?.showLoading ?? false))
                                TextButton(
                                  child: Text('${stateManager?.showLoading ?? false}'),
                                  onPressed: () async {
                                    await _insertRow();
                                    setState(() {});
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Future<void> _insertRow({int rowIdx = 0}) async {
    if (stateManager == null) return;
    stateManager!.setShowLoading(true);
    _footerKey.currentState?.setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    stateManager!.insertRows(
        rowIdx,
        List.generate(5, (index) {
          PlutoRow row = PlutoRow(
            cells: {
              'id': PlutoCell(value: 'user${stateManager!.refRows.length + 1}'),
              'name': PlutoCell(value: 'Mike'),
              'amount': PlutoCell(value: 10),
              'age': PlutoCell(value: 20, enabled: false),
              'role': PlutoCell(value: 'Programmer'),
              'joined': PlutoCell(value: '2021-01-01'),
              'working_time': PlutoCell(value: '09:00'),
              'salary': PlutoCell(value: 300),
            },
          );
          return row;
        }));
    stateManager!.setShowLoading(false);
    _footerKey.currentState?.setState(() {});
  }
}
