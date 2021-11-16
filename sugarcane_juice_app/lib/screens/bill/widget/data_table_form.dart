import 'package:flutter/material.dart';
import '/models/bill_item.dart';
import '/providers/bill_provider.dart';

class DataTableForm extends StatelessWidget {
  final List<BillItems> billItems;
  final Function(BillItems _billItem) deleteBillItem;
  const DataTableForm({required this.billItems, required this.deleteBillItem});

  @override
  Widget build(BuildContext context) {
    final billColumns = ['الإجمالى', 'الكمية', 'السعر', 'الصنف'];
    return DataTable(
      columns: _getColumns(billColumns),
      rows: _getRow(billItems: billItems, context: context),
      headingTextStyle: Theme.of(context)
          .textTheme
          .merge(
            TextTheme(
              headline6: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
          .headline6,
      horizontalMargin: 0.0,
      showCheckboxColumn: false,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map(
        (column) => DataColumn(
          // numeric: true,
          label: SizedBox(
            width: 50,
            child: Text(
              column,
              // textAlign: TextAlign.center,
            ),
          ),
        ),
      )
      .toList();

  List<DataRow> _getRow(
          {required List<BillItems> billItems,
          required BuildContext context}) =>
      billItems.map(
        (billItem) {
          billItem.item.total = BillProvider.getItemsTotal(
            price: billItem.price,
            quentity: billItem.quentity,
          );
          final cells = [
            billItem.item.name,
            billItem.price,
            billItem.quentity,
            billItem.item.total,
          ].reversed.toList();

          return DataRow(
            cells: _getCells(cells),
            onSelectChanged: (value) => deleteBillItem(billItem),
          );
        },
      ).toList();

  List<DataCell> _getCells(List<dynamic> cells) => cells
      .map(
        (cell) => DataCell(
          SizedBox(
            width: 50,
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
}
