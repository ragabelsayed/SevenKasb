import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/helper/box.dart';
import '/widget/toast_view.dart';
import '/providers/offLine_provider.dart';
import '/models/user.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/bill.dart';
import '/providers/bill_provider.dart';
import './bill_item_input_form.dart';
import './custom_bottom_sheet.dart';
import './data_table_form.dart';
import '/widget/alert_view.dart';
import '/widget/dialog_title.dart';
import '/widget/rounded_text_btn.dart';

class BillInputForm extends StatefulWidget {
  final FToast fToast;
  const BillInputForm({Key? key, required this.fToast}) : super(key: key);

  @override
  _BillInputFormState createState() => _BillInputFormState();
}

class _BillInputFormState extends State<BillInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _billItemBox = Boxes.getBillItemsBox();
  final _billBox = Boxes.getBillsBox();
  bool _isBillItemEmpty = false;
  bool _isWaiting = false;
  bool _saveItOnce = false;

  late bool _isOffline;
  late Bill _bill;

  @override
  void initState() {
    super.initState();
    _isOffline = context.read(isOffLineProvider).state;
    if (_isOffline) {
      _bill = Bill(
        user: User(),
        type: 0,
        total: 0.0,
        paid: 0.0,
        clientName: '',
        dateTime: DateTime.now(),
        billItems: [],
        offlineBillItems: HiveList(_billItemBox, objects: []),
      );
      context.read(billOfflineProvider.notifier).addBill(_bill);
    } else {
      _bill = Bill(
        user: User(),
        type: 0,
        total: 0.0,
        paid: 0.0,
        clientName: '',
        dateTime: DateTime.now(),
        billItems: [],
        offlineBillItems: HiveList(_billItemBox, objects: []),
      );
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_bill.billItems.isEmpty) {
      setState(() => _isBillItemEmpty = true);
    }
    if (_isValid && _bill.billItems.isNotEmpty) {
      _formKey.currentState!.save();
      setState(() => _saveItOnce = false);
      try {
        await context.read(addBillProvider).addBill(bill: _bill);
        Navigator.pop(context);
        widget.fToast.showToast(
          child: const ToastView(
            message: '???????? ?????????? ??????????????',
            success: true,
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } catch (e) {
        await _billItemBox.addAll(_bill.billItems);
        _bill.offlineBillItems!.addAll(_bill.billItems);
        await _billBox.add(_bill);
        await _bill.save();
        Navigator.pop(context);
        widget.fToast.showToast(
          child: const ToastView(
            message: '?????? ?????? ???????? ???? ?????????? ?????? ????????',
            success: true,
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      }
    } else {
      setState(() {
        _isWaiting = false;
        _saveItOnce = false;
      });
    }
  }

  Future<void> _saveFormOffLine() async {
    final _isValid = _formKey.currentState!.validate();
    if (_bill.offlineBillItems!.isEmpty) {
      setState(() => _isBillItemEmpty = true);
    }
    if (_isValid && _bill.offlineBillItems!.isNotEmpty) {
      _formKey.currentState!.save();
      await context.read(billOfflineProvider.notifier).upadteCurrentBill(_bill);
      setState(() => _saveItOnce = false);
      Navigator.pop(context);
      widget.fToast.showToast(
        child: const ToastView(
          message: '???? ?????????? ????????????',
          success: true,
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
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
                  const DialogTitle(name: '?????? ????????????/??????????????'),
                  _buildTextFormField(
                    hintText: '   ??????????',
                    error: AppConstants.nameError,
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    onSave: (value) => _bill.clientName = value,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const DialogTitle(name: '???????? ??????????: '),
                      Container(
                        height: 40,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 6),
                              blurRadius: 10,
                              color: const Color(0xFFB0B0B0).withOpacity(0.2),
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
                          child: const Icon(Icons.add, size: 27),
                          onPressed: () => showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => BillItemForm(
                              billItem: (billItems) {
                                if (!_isOffline) {
                                  setState(() {
                                    _bill.billItems.add(billItems);
                                    _isBillItemEmpty = false;
                                  });
                                } else {
                                  setState(() async {
                                    await _billItemBox.add(billItems);
                                    setState(() =>
                                        _bill.offlineBillItems!.add(billItems));
                                    await _bill.save();
                                    _isBillItemEmpty = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_isBillItemEmpty)
                    const Text(
                      '?????????? ?????????? ?????? ???? ???????? ??????????',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.red),
                    ),
                  if (_isBillItemEmpty) const SizedBox(height: 10),
                  DataTableForm(
                    billItems:
                        _isOffline ? _bill.offlineBillItems! : _bill.billItems,
                    deleteBillItem: (_billItem) => showDialog(
                      context: context,
                      builder: (context) => AlertView(
                        message: '???? ?????? ?????????????? ???? ?????? ?????? ????????????',
                        onpress: () {
                          if (!_isOffline) {
                            setState(() {
                              _bill.total -= _billItem.item.total;
                              _bill.billItems.remove(_billItem);
                            });
                          } else {
                            setState(() {
                              _bill.total -= _billItem.item.total;
                              _bill.offlineBillItems!.remove(_billItem);
                              _billItem.delete();
                            });
                          }
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
          if (_isWaiting && !_isOffline)
            FutureBuilder(
              future: _saveItOnce
                  ? _saveForm()
                  : Future.delayed(const Duration(milliseconds: 3)),
              builder: (context, snapshot) => const Center(
                child: CircularProgressIndicator(
                  color: Palette.primaryColor,
                  backgroundColor: Palette.primaryLightColor,
                ),
              ),
            ),
          if (_isWaiting && _isOffline)
            FutureBuilder(
              future: _saveItOnce
                  ? _saveFormOffLine()
                  : Future.delayed(const Duration(milliseconds: 3)),
              builder: (context, snapshot) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                  backgroundColor: Palette.primaryLightColor,
                ),
              ),
            ),
          CustomBottomSheet(
            isOffline: _isOffline,
            bill: _bill,
            textField: Opacity(
              opacity: _isWaiting ? 0.5 : 1.0,
              child: _buildTextFormField(
                hintText: '    0.0',
                initialValue: '0.0',
                error: AppConstants.priceError,
                type: TextInputType.number,
                isUpdated: true,
                isNamberOnly: true,
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
                text: '??????',
                onPressed: !_isWaiting ? () => setWaiting() : () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String hintText,
    String? initialValue,
    required String error,
    required TextInputType type,
    required TextInputAction action,
    bool isNamberOnly = false,
    bool isUpdated = false,
    required Function(String) onSave,
  }) {
    return TextFormField(
      keyboardType: type,
      textInputAction: action,
      maxLines: 1,
      textDirection: TextDirection.rtl,
      inputFormatters: isNamberOnly
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))]
          : null,
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
      initialValue: initialValue,
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
