import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/widget/menu_widget.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BillScreen extends ConsumerWidget {
  static const routName = '/bill';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bill = watch(billProvider);
    bill.fetchAndSetData();
    List<Bill> billList = bill.items;
    print('${billList[1].clientName}');
    // print('${billList[1].billItems[1].itemName}');
    print('${billList[1].dateTime.year}');
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle:
        //     SystemUiOverlayStyle(statusBarColor: Palette.primaryLightColor),
        title: Text('Bills'),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
      ),
      body: _buildDataTable(billList: billList, context: context),
    );
  }

  Widget _buildDataTable(
      {required List<Bill> billList, required BuildContext context}) {
    final columns = ['ClientName', 'ItemName', 'Data', ''];
    return SingleChildScrollView(
      child: DataTable(
        columns: _getColumns(columns),
        rows: _getRow(bills: billList, context: context),
        // dataRowColor:
        //     MaterialStateProperty.resolveWith<Color>((states) => Colors.amber),
        // dividerThickness: 5.0,
        // checkboxHorizontalMargin: 100,
        columnSpacing: 40,
        // decoration: BoxDecoration(
        //   border: Border(bottom: BorderSide()),
        // ),
        showBottomBorder: true,
      ),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();

  List<DataRow> _getRow(
          {required List<Bill> bills, required BuildContext context}) =>
      bills.map(
        (bill) {
          final cells = [bill.clientName, bill.price, bill.dateTime.year];
          // return DataRow(
          //   cells: _getCells(bill),
          // );
          return DataRow(
            cells: [
              ..._getCells(cells),
              DataCell(
                TextButton(
                  child: Icon(
                    Icons.forward_rounded,
                    size: 30,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Column(
                            children: [],
                          ),
                        );
                      },
                    );
                  },
                ),
                //   ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.amberAccent,
                //       // onPrimary: Colors.amber,
                //     ),
                //     onPressed: () {},
                //     child: Icon(Icons.forward_rounded),
                //   ),
              ),
            ],
          );
        },
      ).toList();

  List<DataCell> _getCells(List<dynamic> cells) {
    var cellList = cells
        .map(
          (cell) => DataCell(
            Text('$cell'),
            // placeholder: true,
          ),
        )
        .toList();
    return cellList;
  }
}
