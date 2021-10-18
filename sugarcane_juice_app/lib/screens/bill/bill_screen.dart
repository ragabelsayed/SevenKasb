import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/screens/bill/new_bill_screen.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/bill_view.dart';
import 'package:sugarcane_juice_app/widget/banner_message.dart';
import 'package:sugarcane_juice_app/widget/menu_widget.dart';

class BillScreen extends StatelessWidget {
  static const routName = '/bill';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الفواتير',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
      body: FutureBuilder(
        future: context.read(billProvider).fetchAndSetData().catchError(
              (e) => getBanner(context: context, errorMessage: e.toString()),
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer(
              builder: (context, watch, child) {
                final billList = watch(billProvider).items;
                return _buildDataTable(billList: billList, context: context);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'إضافة فاتورة شراء جديدة',
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.pushNamed(context, NewBillScreen.routName);
        },
      ),
    );
  }

  Widget _buildDataTable(
      {required List<Bill> billList, required BuildContext context}) {
    final columns = [
      'عرض',
      'التاريخ',
      'العميل',
      'الكود',
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DataTable(
        columns: _getColumns(columns),
        rows: _getRow(bills: billList, context: context),
        headingTextStyle: Theme.of(context).textTheme.headline6,
        columnSpacing: MediaQuery.of(context).size.width / 8,

        // dataRowColor:
        //     MaterialStateProperty.resolveWith<Color>((states) => Colors.amber),
        // dividerThickness: 5.0,
        // checkboxHorizontalMargin: 100,
        // horizontalMargin: 10.0,
        horizontalMargin: 0.0,
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
          numeric: true,
          label: SizedBox(
            width: 56,
            child: Text(
              column,
              textAlign: TextAlign.center,
            ),
          ),
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
                  child: Transform.rotate(
                    angle: 600,
                    origin: Offset(0.0, 0.0),
                    child: Icon(
                      Icons.forward_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
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
            ].reversed.toList(),
          );
        },
      ).toList();

  List<DataCell> _getCells(List<dynamic> cells) {
    var cellList = cells
        .map(
          (cell) => DataCell(
            SizedBox(
              width: 56,
              child: Text(
                '$cell',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // placeholder: true,
          ),
        )
        .toList();
    return cellList;
  }
}
