import 'package:flutter/material.dart';
import '/models/bill.dart';
import 'package:intl/intl.dart' as intl;
import 'bill_view.dart';

class DataTableView extends StatelessWidget {
  final List<Bill> bills;
  const DataTableView({Key? key, required this.bills}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = [
      'عرض',
      'التاريخ',
      'العميل',
      'الكود',
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      physics: const AlwaysScrollableScrollPhysics(),
      child: DataTable(
        columns: _getColumns(columns),
        rows: _getRow(bills: bills, context: context),
        headingTextStyle: Theme.of(context).textTheme.headline6,
        columnSpacing: MediaQuery.of(context).size.width / 10,
        horizontalMargin: 0.0,
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
            intl.DateFormat.Md().format(bill.dateTime)
          ];
          return DataRow(
            cells: [
              ..._getCells(cells),
              DataCell(
                TextButton(
                  child: Transform.rotate(
                    angle: 600,
                    origin: const Offset(0.0, 0.0),
                    child: const Icon(
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
