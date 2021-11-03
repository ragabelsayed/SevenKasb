import 'package:flutter/material.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/user.dart';
import '../../../widget/alert_view.dart';
import '/widget/dialog_title.dart';
import '/widget/rounded_text_btn.dart';

class UserForm extends StatefulWidget {
  final User user;
  const UserForm({required this.user});
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _iswaiting = false;

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      try {
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();
      }
    }
  }

  void setWaiting() {
    setState(() {
      _iswaiting = !_iswaiting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            DialogTitle(name: 'إسم المستخدم: '),
            const SizedBox(height: 5),
            _buildTextFormField(
              initValue: widget.user.userName ?? '',
              error: 'قُمْ بإدخال اسم المستخدم',
              type: TextInputType.name,
              action: TextInputAction.next,
              onSave: (value) {},
            ),
            const SizedBox(height: 5),
            DialogTitle(name: 'إسم الشهرة: '),
            const SizedBox(height: 5),
            _buildTextFormField(
              initValue: widget.user.knownAs ?? '',
              error: 'قُمْ بإدخال اللقب',
              type: TextInputType.emailAddress,
              action: TextInputAction.next,
              onSave: (value) {},
            ),
            const SizedBox(height: 5),
            DialogTitle(name: 'تاريخ الميلاد: '),
            const SizedBox(height: 5),
            _buildTextFormField(
              initValue: widget.user.dateOfBirth ?? '00 / 00 /0000',
              error: 'قُمْ بإدخال تاريخ الميلاد',
              type: TextInputType.emailAddress,
              action: TextInputAction.next,
              onSave: (value) {},
            ),
            const SizedBox(height: 5),
            DialogTitle(name: 'المدينة: '),
            const SizedBox(height: 5),
            _buildTextFormField(
              initValue: widget.user.city ?? 'Mansoura',
              error: 'قُمْ بإدخال المدينة',
              type: TextInputType.name,
              action: TextInputAction.next,
              onSave: (value) {},
            ),
            const SizedBox(height: 5),
            DialogTitle(name: 'رقم الهاتف: '),
            const SizedBox(height: 5),
            _buildTextFormField(
              initValue: widget.user.telephone ?? '00-000-000-000',
              error: 'قُمْ بإدخال رقم الهاتف',
              type: TextInputType.phone,
              action: TextInputAction.done,
              onSave: (value) {},
            ),
            const SizedBox(height: 50),
            RoundedTextButton(
              text: 'تعديل',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertView(
                    isSave: true,
                    message: 'هل انت متأكد من حفظ هذا التعديل؟',
                    onpress: () {
                      _saveForm();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String initValue,
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
        hintTextDirection: TextDirection.rtl,
        border: AppConstants.border,
        errorBorder: AppConstants.errorBorder,
        focusedBorder: AppConstants.focusedBorder,
      ),
      initialValue: initValue,
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
