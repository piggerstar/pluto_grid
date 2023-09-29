import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'data.dart';

class PlutoAutoSizeTable extends StatefulWidget {
  const PlutoAutoSizeTable({super.key});

  @override
  State<PlutoAutoSizeTable> createState() => _PlutoAutoSizeTableState();
}

class _PlutoAutoSizeTableState extends State<PlutoAutoSizeTable> {
  final GlobalKey _footerKey = GlobalKey();

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  PlutoGridStateManager? stateManager;
  final ScrollController controller = ScrollController();

  List<PlutoRow> get getRows => [];

  List<PlutoColumn> get columns => simpleColumns;

  List<PlutoColumnGroup>? get getColumnGroups => null;

  Future<void> _insertRow({int rowIdx = 0}) async {
    if (stateManager == null) return;
    stateManager!.setShowLoading(true);

    _footerKey.currentState?.setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    stateManager!.insertRows(
        rowIdx,
        List.generate(5, (index) {
          bool enabled = (stateManager!.refRows.length + index).isEven ? false : true;
          PlutoRow row = PlutoRow(
            cells: {
              'id': PlutoCell(value: 'user${stateManager!.refRows.length + index}', enabled: enabled, showCheckboxTooltip: !enabled, checkboxTooltipMessage: 'This is a tooltip'),
              'name': PlutoCell(value: 'Mike'),
              'amount': PlutoCell(value: 10),
              'age': PlutoCell(value: '', enabled: enabled),
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
      autoSize: true,
      scrollController: controller,
      columns: columns,
      rows: getRows,
      columnGroups: getColumnGroups,
      autoSizeHeightOffset: (stateManager?.refRows.isEmpty ?? true) ? 180 : 0,
      noRowsWidget: Container(height: 50, color: Colors.lightBlueAccent, child: const Text('No data.')),
      useCustomFooter: true,
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
      onColumnsHide: (PlutoGridOnColumnsHideEvent event) {
        print('onColumnsHide $event');
        print(stateManager?.refColumns.firstWhere((element) => element.field == 'id').frozen);
      },
      configuration: const PlutoGridConfiguration(
        scrollbar: PlutoGridScrollbarConfig(isAlwaysShown: false),
        style: PlutoGridStyleConfig(
          activatedColor: Colors.white,
          gridBorderColor: Colors.green,
          borderColor: Colors.lightBlueAccent,
          rowHeight: 80,
          columnHeight: 46,
          enableCellBorderHorizontal: true,
          enableCellBorderVertical: true,
          enableActiveColorOnDisabledCell: true,
          enableActiveColorOnReadOnlyCell: true,
          cellColorInReadOnlyState: Colors.white,
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
                          await _insertRow(rowIdx: stateManager!.refRows.length);
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
