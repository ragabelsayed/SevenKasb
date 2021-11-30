import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sugarcane_juice/screens/bill/widget/dropdown_icon_btn.dart';
import '/models/bill_item.dart';
import '/widget/save_cancel_btns.dart';
import '/providers/item_provider.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/item.dart';
import '/models/unit.dart';

class BillItemForm extends StatefulWidget {
  final bool isOffline;
  final Function(BillItems billItems) billItem;
  final Function(bool billItemError) hasError;
  const BillItemForm({
    Key? key,
    this.isOffline = false,
    required this.billItem,
    required this.hasError,
  }) : super(key: key);

  @override
  State<BillItemForm> createState() => _BillItemFormState();
}

class _BillItemFormState extends State<BillItemForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  bool _iswaiting = false;
  late BillItems _billItems;

  @override
  void initState() {
    super.initState();
    _billItems = BillItems(
      price: 0.0,
      quentity: 0.0,
      item: Item(
        name: '',
        unit: Unit(
          name: '',
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      try {
        // final newUnit =
        //     await context.read(unitProvider).addUnit(_billItems.item.unit);
        // _billItems.item.unit = newUnit;

        final newItem =
            await context.read(itemProvider).addItem(_billItems.item);
        _billItems.item = newItem;

        widget.billItem(_billItems);
        widget.hasError(false);
        Navigator.of(context).pop();
      } catch (e) {
        widget.hasError(true);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _saveFormOffLine() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      await Future.delayed(const Duration(seconds: 1));
      widget.billItem(_billItems);
      widget.hasError(false);
      Navigator.of(context).pop();
    }
  }

  void setWaiting() => setState(() => _iswaiting = !_iswaiting);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _iswaiting ? Colors.transparent : null,
      elevation: _iswaiting ? 0.0 : null,
      child: _iswaiting
          ? FutureBuilder(
              future: widget.isOffline ? _saveFormOffLine() : _saveForm(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Palette.primaryColor,
                      backgroundColor: Palette.primaryLightColor,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (widget.isOffline) Navigator.of(context).pop();
                  return const Center(
                    child: FaIcon(
                      FontAwesomeIcons.checkCircle,
                      color: Colors.green,
                      size: 50,
                    ),
                  );
                } else {
                  return const Center(
                    child: FaIcon(
                      FontAwesomeIcons.checkCircle,
                      color: Colors.green,
                      size: 50,
                    ),
                  );
                }
              },
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'إضافة صنف',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 10),
                    _buildTextFormField(
                      hintText: '    اسم الصنف',
                      error: AppConstants.nameError,
                      type: TextInputType.name,
                      action: TextInputAction.next,
                      onSave: (value) {
                        _billItems.item.name = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextFormField(
                      hintText: '    سعر الصنف',
                      error: AppConstants.priceError,
                      type: TextInputType.number,
                      action: TextInputAction.next,
                      onSave: (value) {
                        _billItems.price = double.parse(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextFormField(
                      hintText: '    الكمية',
                      error: AppConstants.quentityError,
                      type: TextInputType.number,
                      action: TextInputAction.next,
                      onSave: (value) {
                        _billItems.quentity = double.parse(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextFormField(
                      hintText: '    وحدة القياس',
                      error: AppConstants.unitError,
                      type: TextInputType.emailAddress,
                      action: TextInputAction.done,
                      controller: controller,
                      dropDown: DropdownIconBtn(
                        newunit: (unit) => controller.text = unit.name,
                      ),
                      onSave: (value) => _billItems.item.unit.name = value,
                    ),
                    // const SizedBox(height: 10),
                    // _buildTextFormField(
                    //   hintText: '    وحدة القياس',
                    //   error: AppConstants.unitError,
                    //   type: TextInputType.emailAddress,
                    //   action: TextInputAction.done,
                    //   onSave: (value) {
                    //     _billItems.item.unit.name = value;
                    //   },
                    // ),
                    const SizedBox(height: 30),
                    SaveAndCancelBtns(onSave: () => setWaiting())
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField _buildTextFormField({
    required String hintText,
    required String error,
    required TextInputType type,
    required TextInputAction action,
    TextEditingController? controller,
    Widget? dropDown,
    required Function(String) onSave,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: action,
      keyboardType: type,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      // textAlign: TextAlign.center,
      decoration: InputDecoration(
        fillColor: Palette.primaryLightColor,
        filled: true,
        hintText: hintText,
        hintMaxLines: 1,
        hintTextDirection: TextDirection.rtl,
        suffixIcon: dropDown,
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
}
