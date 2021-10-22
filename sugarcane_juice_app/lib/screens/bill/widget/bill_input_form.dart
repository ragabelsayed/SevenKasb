import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/bill_item_input_form.dart';
import 'package:sugarcane_juice_app/widget/banner_message.dart';
import 'package:sugarcane_juice_app/widget/dialog_remove.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';
import 'package:sugarcane_juice_app/widget/error_view.dart';
import 'package:sugarcane_juice_app/widget/rounded_text_btn.dart';

class BillInputForm extends StatefulWidget {
  const BillInputForm({Key? key}) : super(key: key);

  @override
  _BillInputFormState createState() => _BillInputFormState();
}

class _BillInputFormState extends State<BillInputForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isBillItemEmpty = false;

  late Bill _bill = Bill(
    user: {},
    type: 0,
    total: 0.0,
    paid: 0.0,
    clientName: '',
    dateTime: DateTime.now(),
    billItems: [],
  );

  void _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_bill.billItems.isEmpty) {
      setState(() => _isBillItemEmpty = true);
    }
    if (_isValid && _bill.billItems.isNotEmpty) {
      _formKey.currentState!.save();
      await context.read(addBillProvider).addBill(_bill).onError(
            (error, stackTrace) =>
                getBanner(context: context, errorMessage: error.toString()),
          );
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
                  action: TextInputAction.next,
                  onSave: (value) {
                    _bill.clientName = value;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DialogTitle(
                      name: 'إضافة صنف: ',
                    ),
                    Container(
                      // height: 35,
                      // width: 35,
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 6),
                            blurRadius: 10,
                            color: Color(0xFFB0B0B0).withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Palette.primaryLightColor,
                          primary: Colors.amber,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 27,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => BillItemForm(
                            hasError: (billItemError) {
                              if (billItemError) {
                                getBanner(
                                  context: context,
                                  errorMessage:
                                      'لم تتم اضافة الصنف تاكد من الاتصال بالشبكة الصحيحه',
                                );
                              } else {
                                return;
                              }
                            },
                            billItem: (billItems) {
                              setState(() {
                                _bill.billItems.add(billItems);
                                _isBillItemEmpty = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_isBillItemEmpty)
                  Text(
                    'برجاء إضافة صنف او منتج اولا',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.red),
                  ),
                if (_isBillItemEmpty) const SizedBox(height: 10),
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
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 10,
              ),
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
                      Text('${BillProvider.sumTotal(_bill)}'),
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
                          isUpdated: true,
                          action: TextInputAction.done,
                          onSave: (newValue) {
                            if (double.parse(newValue) > 0) {
                              setState(
                                  () => _bill.paid = double.parse(newValue));
                            }
                          },
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text('${_bill.paid}'),
                    ],
                  ),
                  Divider(color: Colors.amber),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      DialogTitle(name: 'ألباقى: '),
                      Text('${BillProvider.getRemaining(_bill)}'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  RoundedTextButton(text: 'حفظ', onPressed: () => _saveForm()),
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
          setState(() {
            _bill.paid = double.parse(value);
          });
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
      showCheckboxColumn: false,
      // checkboxHorizontalMargin: 5,
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
            onSelectChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => RemoveDialog(
                  message: 'هل انت متاكد من حذف هذا الصنف؟',
                  onpress: () {
                    setState(() => _bill.billItems.remove(billItem));
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
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
