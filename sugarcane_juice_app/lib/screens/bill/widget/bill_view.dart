import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:intl/intl.dart' as intl;
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';
import 'package:sugarcane_juice_app/widget/rounded_text_btn.dart';

class BillView extends StatelessWidget {
  final Bill bill;
  const BillView({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.rtl,
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitle(name: 'فاتورة شراء'),
              const SizedBox(height: 10),
              _buildRowView(
                context,
                name: ' :رقم الفاتورة',
                value: '${bill.id}',
              ),
              const SizedBox(height: 3),
              _buildRowView(
                context,
                name: ' :إسم العميل/المُورد',
                value: '${bill.clientName}',
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    ' :التاريخ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${intl.DateFormat.yMd().format(bill.dateTime)}',
                    // style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    '${intl.DateFormat.Hm().format(bill.dateTime)}',
                    // style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              Divider(thickness: 2),
              _buildDataTable(bill: bill, context: context),
              const SizedBox(height: 10),
              _buildRowView(
                context,
                name: ' :الإجمالى',
                value: '${BillNotifier.sumTotal(bill)}',
              ),
              const SizedBox(height: 3),
              _buildRowView(
                context,
                name: ' :المدفوع',
                value: '${bill.paid}',
              ),
              const SizedBox(height: 3),
              _buildRowView(
                context,
                name: ' :ألباقى',
                value: '${BillNotifier.getRemaining(bill)}',
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

  Row _buildRowView(BuildContext context,
      {required String name, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          value,
          // style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }

  Widget _buildDataTable({required Bill bill, required BuildContext context}) {
    final billColumns = ['الإجمالى', 'الكمية', 'السعر', 'الصنف'];
    return DataTable(
      columns: _getColumns(billColumns),
      rows: _getRow(billItems: bill.billItems, context: context),
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
            billItem.item.price,
            '${billItem.item.unit.name} ${billItem.item.quentity}',
            BillNotifier.getItemsTotal(
              price: billItem.item.price,
              quentity: billItem.item.quentity,
            ),
          ].reversed.toList();
          return DataRow(
            cells: _getCells(cells),
          );
        },
      ).toList();

  List<DataCell> _getCells(List<dynamic> cells) => cells
      .map(
        (cell) => DataCell(
          Text('$cell'),
          placeholder: true,
        ),
      )
      .toList();
}
