import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/bill_view.dart';
import 'package:sugarcane_juice_app/widget/menu_widget.dart';

class BillScreen extends ConsumerWidget {
  static const routName = '/bill';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bill = watch(billProvider);
    late List<Bill> billList;
    // bill.fetchAndSetData().whenComplete(() {
    //   billList = bill.items;
    //   print('${billList[1].id}');
    //   print('${billList[1].clientName}');
    //   print('${billList[1].paid}');
    //   print('${billList[1].price}');
    //   print('${billList[1].dateTime.year}');
    //   print('${billList[1].type}');
    //   print('1111111111');
    //   print('${billList[1].billItems[0].itemName}');
    //   print('${billList[1].billItems[0].id}');
    //   print('${billList[1].billItems[0].price}');
    //   print('${billList[1].billItems[0].quentity}');
    //   print('222222222');
    //   print('${billList[1].billItems[0].item.id}');
    //   print('${billList[1].billItems[0].item.name}');
    //   print('${billList[1].billItems[0].item.price}');
    //   print('${billList[1].billItems[0].item.quentity}');
    //   print('${billList[1].billItems[0].item.type}');
    //   print('333333');
    //   print('${billList[1].billItems[0].item.unit.id}');
    //   print('${billList[1].billItems[0].item.unit.name}');
    //   // print('${billList[1].billItems[1].itemName}');
    // });

    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle:
        //     SystemUiOverlayStyle(statusBarColor: Palette.primaryLightColor),
        title: Text('Bills'),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
      ),
      // body: Text('ggggggggggggg'),
      body: FutureBuilder(
        future:
            bill.fetchAndSetData().whenComplete(() => billList = bill.items),
        builder: (ctx, authResultsnapshot) =>
            authResultsnapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : _buildDataTable(billList: billList, context: context),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new bill',
        child: Icon(Icons.add),
        // backgroundColor: Colors.green,
        backgroundColor: Colors.amber,
        onPressed: () {},
      ),
    );
  }

  Widget _buildDataTable(
      {required List<Bill> billList, required BuildContext context}) {
    final columns = ['BillId', 'ClientName', 'Data', ''];
    return SingleChildScrollView(
      child: DataTable(
        columns: _getColumns(columns),
        rows: _getRow(bills: billList, context: context),
        // dataRowColor:
        //     MaterialStateProperty.resolveWith<Color>((states) => Colors.amber),
        // dividerThickness: 5.0,
        // checkboxHorizontalMargin: 100,
        // columnSpacing: 40,
        // horizontalMargin: 10.0,
        // decoration: BoxDecoration(
        //   border: Border(bottom: BorderSide()),
        // ),
        showBottomBorder: true,
      ),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map(
        (column) => DataColumn(
          // numeric: true,
          label: column.isNotEmpty
              ? Text(column)
              : FaIcon(FontAwesomeIcons.receipt),
        ),
      )
      .toList();

  List<DataRow> _getRow(
          {required List<Bill> bills, required BuildContext context}) =>
      bills.map(
        (bill) {
          final cells = [
            bill.id,
            bill.clientName,
            DateFormat.Md().format(bill.dateTime)
          ];
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
                        return BillView(bill: bill);
                      },
                    );
                  },
                ),

                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.amberAccent,
                //     // onPrimary: Colors.amber,
                //   ),
                //   onPressed: () {},
                //   child: Icon(Icons.forward_rounded),
                // ),
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
