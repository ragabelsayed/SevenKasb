import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/dropdown_item_btn.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';

class BillInputForm extends StatefulWidget {
  const BillInputForm({Key? key}) : super(key: key);

  @override
  _BillInputFormState createState() => _BillInputFormState();
}

class _BillInputFormState extends State<BillInputForm> {
  final _formKey = GlobalKey<FormState>();

  late Bill _bill = Bill(
    type: 0,
    price: 0.0,
    paid: 0.0,
    clientName: '',
    dateTime: DateTime.now(),
    billItems: [],
  );

  void _saveForm() {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      // context.read(itemProvider).addItem(_item);
      Navigator.of(context).pop();
    }
  }

  String _getItemsTotal({required String price, required String quentity}) {
    return (double.parse(price) * double.parse(quentity)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            DialogTitle(name: 'إسم العميل/المُورد'),
            _buildTextFormField(
              hintText: 'الاسم',
              error: AppConstants.nameError,
              type: TextInputType.name,
              action: TextInputAction.done,
              onSave: (value) {
                _bill.clientName = value;
              },
            ),
            const SizedBox(height: 10),
            DropdownItemBtn(
              oldBillItem:
                  _bill.billItems.isNotEmpty ? _bill.billItems.last : null,
              billItem: (item) {
                setState(() {
                  _bill.billItems.add(BillItems(price: 0.0, item: item));
                });
              },
            ),
            const SizedBox(height: 10),
            _buildDataTable(context: context)
          ],
        ),
      ),
    );
  }

  Row _buildItemView(Item item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          item.name,
          textAlign: TextAlign.center,
        ),
        Text(
          item.price,
          textAlign: TextAlign.center,
        ),
        Text(
          item.quentity,
          textAlign: TextAlign.center,
        ),
        Text(
          _getItemsTotal(price: item.price, quentity: item.quentity),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  TextFormField _buildTextFormField({
    required String hintText,
    required String error,
    required TextInputType type,
    required TextInputAction action,
    required Function(String) onSave,
  }) {
    return TextFormField(
      keyboardType: type,
      textInputAction: action,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      decoration: InputDecoration(
        fillColor: Palette.primaryLightColor,
        filled: true,
        hintText: hintText,
        hintMaxLines: 1,
        hintTextDirection: TextDirection.rtl,
        border: AppConstants.border,
        errorBorder: AppConstants.errorBorder,
        focusedBorder: AppConstants.focusedBorder,
      ),
      onFieldSubmitted: (value) {
        if (value.isNotEmpty) {
          _formKey.currentState!.validate();
        }
      },
      validator: (newValue) {
        if (newValue!.isEmpty) {
          return error;
        }
      },
      onSaved: (newValue) => onSave(newValue!),
    );
  }

  Widget _buildDataTable({required BuildContext context}) {
    final billColumns = ['الإجمالى', 'الكمية', 'السعر', 'الصنف'];
    return DataTable(
      columns: _getColumns(billColumns),
      rows: _getRow(billItems: _bill.billItems, context: context),
      headingTextStyle: Theme.of(context)
          .textTheme
          .merge(
            TextTheme(
              headline6: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
          .headline6,
      // columnSpacing: MediaQuery.of(context).size.width / 8,
      horizontalMargin: 0.0,
      // showBottomBorder: true,

      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(
      //       width: 0.5,
      //       color: Colors.amber,
      //     ),
      //   ),
      // ),
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
          final cells = [
            billItem.item.name,
            billItem.item.price,
            billItem.item.quentity,
            _getItemsTotal(
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
