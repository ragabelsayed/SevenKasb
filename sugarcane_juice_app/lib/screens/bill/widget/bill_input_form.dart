import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
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
            // DropdownItemBtn(
            //   oldBillItem: _bill.billItems.first,
            //   billItemId:(newBillItem) {
            //     return ;
            //   },

            // ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                DialogTitle(name: 'الصنف'),
                DialogTitle(name: 'السعر'),
                DialogTitle(name: 'الكمية'),
                DialogTitle(name: 'الإجمالى'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [Text('dd')],
            ),
          ],
        ),
      ),
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
}
