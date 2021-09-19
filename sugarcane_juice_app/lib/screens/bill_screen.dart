import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/widget/menu_widget.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BillScreen extends ConsumerWidget {
  static const routName = '/bill';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bill = watch(billProvider);
    bill.fetchAndSetData();
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle:
        //     SystemUiOverlayStyle(statusBarColor: Palette.primaryLightColor),
        title: Text('Bills'),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
      ),
      body:
          // SfDataGrid(source: source, columns: columns)
          DataTable(
        columns: [
          DataColumn(label: Text('Bill 1')),
          DataColumn(label: Text('Bill 2')),
          DataColumn(label: Text('Bill 3')),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(Text('Aaaaaa 1')),
              DataCell(Text('A 2')),
              DataCell(Text('A 3')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('B 1')),
              DataCell(Text('B 2')),
              DataCell(Text('B 3')),
            ],
          ),
        ],
        // dataRowColor:
        //     MaterialStateProperty.resolveWith<Color>((states) => Colors.amber),
        // dividerThickness: 5.0,
        // checkboxHorizontalMargin: 100,
        columnSpacing: 100,
        // decoration: BoxDecoration(
        //   border: Border(bottom: BorderSide()),
        // ),
        showBottomBorder: true,
      ),
    );
  }
}
