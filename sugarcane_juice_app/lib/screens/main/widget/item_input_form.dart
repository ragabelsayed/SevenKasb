import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';

class IputItemForm extends StatefulWidget {
  const IputItemForm({Key? key}) : super(key: key);

  @override
  _IputItemFormState createState() => _IputItemFormState();
}

class _IputItemFormState extends State<IputItemForm> {
  final _formKey = GlobalKey<FormState>();

  void _saveForm() {
    final _isValid = _formKey.currentState!.validate();
    // if (_isValid) {
    //   _formKey.currentState!.save();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'إضافة صنف جديد',
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
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hintText: '    سعر الصنف',
                error: AppConstants.priceError,
                type: TextInputType.number,
                action: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hintText: '    وحدة القياس',
                error: AppConstants.unitError,
                type: TextInputType.emailAddress,
                action: TextInputAction.done,
              ),
              const SizedBox(height: 30),
              _getBtn(context),
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
      onChanged: (value) {
        if (value.isNotEmpty) {
          _formKey.currentState!.validate();
        }
        return;
      },
      validator: (newValue) {
        if (newValue!.isEmpty) {
          return error;
        }
      },
      onSaved: (newValue) {
        // userData['name'] = newValue!;
      },
    );
  }

  Row _getBtn(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Palette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                  ),
                )),
            child: Text('غلق'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Palette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                )),
            child: Text('حفظ'),
            onPressed: () => _saveForm(),
          ),
        ),
      ],
    );
  }
}
