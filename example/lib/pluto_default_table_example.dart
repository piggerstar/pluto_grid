import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'data.dart';

class PlutoDefaultTable extends StatefulWidget {
  const PlutoDefaultTable({super.key});

  @override
  State<PlutoDefaultTable> createState() => _PlutoDefaultTableState();
}

class _PlutoDefaultTableState extends State<PlutoDefaultTable> {
  final GlobalKey _footerKey = GlobalKey();

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  PlutoGridStateManager? stateManager;
  final ScrollController controller = ScrollController();

  List<PlutoRow> get getRows => [];

  List<PlutoColumn> get columns => defaultColumns;

  List<PlutoColumnGroup>? get getColumnGroups => defaultColumnGroups;

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

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      scrollController: controller,
      columns: columns,
      rows: getRows,
      // columnGroups: getColumnGroups,
      noRowsWidget: Container(height: 50, color: Colors.lightBlueAccent, child: const Text('No data.')),
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

        /// getting the table width without the column border (1 px by default)
        double width = context.size!.width - stateManager!.refColumns.length;

        /// resize column using percentage
        for (var element in stateManager!.refColumns.where((element) => !element.hide)) {
          double newWidth = width * (element.percentage ?? 0.1);

          /// this only applied when [autoResizeMode] is set to normal
          stateManager!.resizeColumn(element, newWidth, reset: true, force: true);
        }

        await _insertRow();
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
        columnSize: PlutoGridColumnSizeConfig(),
        style: PlutoGridStyleConfig(
          activatedColor: Colors.white,
          gridBorderColor: Colors.green,
          borderColor: Colors.lightBlueAccent,
          rowHeight: 46,
          columnHeight: 46,
          enableCellBorderHorizontal: true,
          enableCellBorderVertical: true,
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
                        child: const Text('Load more'),
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
    );
  }
}
