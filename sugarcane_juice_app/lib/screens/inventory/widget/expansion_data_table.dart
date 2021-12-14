import 'package:flutter/material.dart';
import '/providers/bill_provider.dart';

class ExpansionDataTable extends StatelessWidget {
  final List<dynamic> cashItemHistory;
  // final List<Map<String, dynamic>> cashItemHistory;
  const ExpansionDataTable({Key? key, required this.cashItemHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = [
      'الإجمالي',
      'الكمية',
      'السعر',
    ];
    return Scrollbar(
      interactive: true,
      radius: const Radius.circular(30),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        child: DataTable(
          columns: _getColumns(columns),
          rows: _getRow(cashHistory: cashItemHistory, context: context),
          headingTextStyle:
              Theme.of(context).textTheme.headline6!.copyWith(fontSize: 15),
          columnSpacing: MediaQuery.of(context).size.width / 5,
          horizontalMargin: 0.0,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.amber)),
          ),
        ),
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
      {required List<dynamic> cashHistory,
      // required List<Map<String, dynamic>> cashHistory,
      required BuildContext context}) {
    List<double> sumQuentity = [];
    List<double> sumTotal = [];
    var list = cashHistory.map(
      (cash) {
        final cells = [
          cash['price'],
          cash['quentity'],
          BillProvider.getItemsTotal(
            price: cash['price'],
            quentity: cash['quentity'],
          )
        ];
        sumQuentity.add(cells[1]);
        sumTotal.add(cells[2]);
        return DataRow(cells: _getCells(cells).reversed.toList());
      },
    ).toList();

    list.add(DataRow(
        cells: _getCells([
      'المجموع',
      getSum(sumQuentity),
      getSum(sumTotal),
    ]).reversed.toList()));
    return list;
  }

  double getSum(List<double> list) {
    double sum1 = 0.0;
    if (list.isNotEmpty) {
      for (var item in list) {
        sum1 += item;
      }
      return sum1;
    } else {
      return sum1;
    }
  }

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
            placeholder: true,
          ),
        )
        .toList();
    return cellList;
  }
}
