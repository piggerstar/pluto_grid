import 'package:example/pluto_auto_size_table_example.dart';
import 'package:example/pluto_default_table_example.dart';
import 'package:flutter/material.dart';

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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Normal PlutoGrid Table with default configuration.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                child: const PlutoDefaultTable(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '1. Using [autoSize] property to calculate the width & height of the table based on the given column & row data.\n'
                '2. All column has been set to auto fit during onLoaded.\n'
                '3. The create footer is rendered with [useCustomFooter] property set to true that will make the footer render independent from the table.\n'
                '4. The name cell has been customized to add border to the text input field.\n'
                '5. The [enableActiveColorOnDisabledCell] style has been set to false that will make the selected cell color to use disabled style when the cell is readonly. \n'
                '6. The age cell has been disabled at row level instead of column level by using [enabled] property on PlutoRow(). This allow more control to disable on specific row cell.\n'
                '    This also achievable by using [checkReadOnly] property on PlutoColumn().\n',
                textAlign: TextAlign.start,
              ),
            ),
            const Center(child: PlutoAutoSizeTable()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
