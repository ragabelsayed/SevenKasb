import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/widget/rounded_text_btn.dart';

class BillView extends StatelessWidget {
  final Bill bill;
  const BillView({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Alasra',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Code:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${bill.id}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ClientName:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${bill.clientName}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${DateFormat.yMd().format(bill.dateTime)}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    '${DateFormat.Hm().format(bill.dateTime)}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              Divider(thickness: 2),
              _buildDataTable(bill: bill, context: context),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${bill.paid}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cash:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${bill.paid}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'The rest:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '00.0',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: RoundedTextButton(
                  text: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable({required Bill bill, required BuildContext context}) {
    final billColumns = ['Product', 'quentity', 'Price', 'Total'];
    return DataTable(
      columns: _getColumns(billColumns),
      rows: _getRow(billItems: bill.billItems, context: context),
      // dataRowColor:
      //     MaterialStateProperty.resolveWith<Color>((states) => Colors.amber),
      // dividerThickness: 5.0,
      // checkboxHorizontalMargin: 100,
      columnSpacing: 30,
      horizontalMargin: 0.0,
      headingRowHeight: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.amber,
          ),
        ),
      ),
      // showBottomBorder: true,
    );
  }

  List<DataColumn> _getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();

  List<DataRow> _getRow(
          {required List<BillItems> billItems,
          required BuildContext context}) =>
      billItems.map(
        (billItem) {
          final cells = [
            billItem.item.name,
            // billItem.item.quentity,
            '${billItem.item.quentity} ${billItem.item.unit.name}',
            billItem.item.price,
            billItem.price
          ];
          return DataRow(
            cells: _getCells(cells),
          );
        },
      ).toList();

  List<DataCell> _getCells(List<dynamic> cells) => cells
      .map(
        (cell) => DataCell(
          Text('$cell'),
          // placeholder: true,
        ),
      )
      .toList();
}
