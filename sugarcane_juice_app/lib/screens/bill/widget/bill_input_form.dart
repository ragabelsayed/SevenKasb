import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
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
    total: 0.0,
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        fit: StackFit.expand,
        textDirection: TextDirection.rtl,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                DialogTitle(name: 'إسم العميل/المُورد'),
                _buildTextFormField(
                  hintText: '   الاسم',
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
                _buildDataTable(context: context),
                const SizedBox(height: 150),
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.18),
                    blurRadius: 30,
                  )
                ],
              ),
              child: Column(
                textDirection: TextDirection.rtl,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      DialogTitle(name: 'الإجمالى: '),
                      Text('${_bill.total}'),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      DialogTitle(name: 'المدفوع: '),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: _buildTextFormField(
                          hintText: '    0.0',
                          error: AppConstants.priceError,
                          type: TextInputType.number,
                          action: TextInputAction.done,
                          isUpdated: true,
                          onSave: (newValue) {
                            if (double.parse(newValue) > 0) {
                              // setState(() {
                              _bill.paid = double.parse(newValue);
                              print(_bill.paid);
                              // });
                            }
                          },
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text('${_bill.paid}'),
                    ],
                  ),
                  // const SizedBox(height: 5),
                  Divider(color: Colors.amber),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      DialogTitle(name: 'ألباقى: '),
                      Text(
                        '${BillNotifier.getRemaining(paid: _bill.paid, total: _bill.total)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String hintText,
    required String error,
    required TextInputType type,
    required TextInputAction action,
    bool isUpdated = false,
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
        if (isUpdated) {
          setState(() {});
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
      decoration: BoxDecoration(
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
          final cells = [
            billItem.item.name,
            billItem.item.price,
            billItem.item.quentity,
            BillNotifier.getItemsTotal(
              price: billItem.item.price,
              quentity: billItem.item.quentity,
            ),
          ].reversed.toList();
          _bill.total += _bill.total +
              BillNotifier.getItemsTotal(
                price: billItem.item.price,
                quentity: billItem.item.quentity,
              );
          print(_bill.total);
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
