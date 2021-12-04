import 'package:flutter/material.dart';
import '/models/bill_item.dart';
import '/widget/save_cancel_btns.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/item.dart';
import '/models/unit.dart';
import 'dropdown_icon_btn.dart';

class BillItemForm extends StatefulWidget {
  final Function(BillItems billItems) billItem;
  const BillItemForm({
    Key? key,
    required this.billItem,
  }) : super(key: key);
  @override
  State<BillItemForm> createState() => _BillItemFormState();
}

class _BillItemFormState extends State<BillItemForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController itemController = TextEditingController();
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
        widget.billItem(_billItems);
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'إختيار الصنف',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              DropdownIconBtn(
                conroller: itemController,
                onSave: (p0) {},
                dropdownValue: (dropdownItemValue) =>
                    _billItems.item = dropdownItemValue,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hintText: 'السعر',
                error: AppConstants.priceError,
                type: TextInputType.number,
                action: TextInputAction.next,
                onSave: (value) {
                  _billItems.price = double.parse(value);
                },
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hintText: 'الكمية',
                error: AppConstants.quentityError,
                type: TextInputType.number,
                action: TextInputAction.next,
                onSave: (value) {
                  _billItems.quentity = double.parse(value);
                },
              ),
              const SizedBox(height: 30),
              SaveAndCancelBtns(onSave: () => _saveForm())
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
      textAlign: TextAlign.center,
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
