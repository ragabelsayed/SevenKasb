import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/models/user.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/bill.dart';
import '/providers/bill_provider.dart';
import './bill_item_input_form.dart';
import './custom_bottom_sheet.dart';
import './data_table_form.dart';
import '/widget/banner_message.dart';
import '/widget/alert_view.dart';
import '/widget/dialog_title.dart';
import '/widget/rounded_text_btn.dart';

class BillInputForm extends StatefulWidget {
  const BillInputForm({Key? key}) : super(key: key);

  @override
  _BillInputFormState createState() => _BillInputFormState();
}

class _BillInputFormState extends State<BillInputForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isBillItemEmpty = false;
  bool _isWaiting = false;
  bool _saveItOnce = false;

  late Bill _bill = Bill(
    user: User(),
    type: 0,
    total: 0.0,
    paid: 0.0,
    clientName: '',
    dateTime: DateTime.now(),
    billItems: [],
  );

  Future<void> _saveForm() async {
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
      setState(() => _saveItOnce = false);
    }
  }

  void setWaiting() {
    setState(() {
      _isWaiting = true;
      _saveItOnce = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOffline = context.read(isOffLineProvider).state;
    print(isOffline);
    return Form(
      key: _formKey,
      child: Stack(
        fit: StackFit.expand,
        textDirection: TextDirection.rtl,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Opacity(
              opacity: _isWaiting ? 0.5 : 1.0,
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
                  DataTableForm(
                    billItems: _bill.billItems,
                    deleteBillItem: (_billItem) => showDialog(
                      context: context,
                      builder: (context) => AlertView(
                        message: 'هل انت متاكد من حذف هذا الصنف؟',
                        onpress: () {
                          setState(() {
                            _bill.total -= _billItem.item.total!;
                            _bill.billItems.remove(_billItem);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
          _isWaiting
              ? FutureBuilder(
                  future: _saveItOnce
                      ? _saveForm()
                      : Future.delayed(const Duration(milliseconds: 3)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    } else {
                      return Center(
                        // child: Icon(Icons.done, color: Colors.green),
                        child: FaIcon(
                          FontAwesomeIcons.checkCircle,
                          color: Colors.green,
                          size: 50,
                        ),
                      );
                    }
                  },
                )
              : SizedBox(),
          CustomBottomSheet(
            bill: _bill,
            textField: Opacity(
              opacity: _isWaiting ? 0.5 : 1.0,
              child: _buildTextFormField(
                hintText: '    0.0',
                error: AppConstants.priceError,
                type: TextInputType.number,
                isUpdated: true,
                action: TextInputAction.done,
                onSave: (newValue) {
                  if (double.parse(newValue) > 0) {
                    setState(() => _bill.paid = double.parse(newValue));
                  }
                },
              ),
            ),
            saveBtn: Opacity(
              opacity: _isWaiting ? 0.5 : 1.0,
              child: RoundedTextButton(
                  text: 'حفظ',
                  onPressed: !_isWaiting
                      ? () {
                          setWaiting();
                        }
                      : () {}),
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
}
