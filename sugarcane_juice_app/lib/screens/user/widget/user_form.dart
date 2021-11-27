import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/providers/auth.dart';
import '/providers/user_provider.dart';
import '/widget/toast_view.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/user.dart';
import '/widget/alert_view.dart';
import '/widget/dialog_title.dart';
import '/widget/rounded_text_btn.dart';

class UserForm extends StatefulWidget {
  final User user;
  final FToast fToast;
  const UserForm({Key? key, required this.user, required this.fToast})
      : super(key: key);
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _iswaiting = false;
  bool _saveItOnce = false;

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      try {
        setState(() => _saveItOnce = false);
        await context.read(updateUserProvider).updateUser(widget.user);
        setState(() => _iswaiting = false);
        toast('تم التحديث بنجاح', true);
        toast('سيتم إعادة تسجيل الدخول', true);
        await Future.delayed(const Duration(seconds: 4));
        await context.read(authProvider.notifier).logOut(context);
      } catch (e) {
        toast('خطأ! لم يتم التحديث', false);
        setState(() => _iswaiting = false);
      }
    }
  }

  void toast(String message, bool isSccuss) => widget.fToast.showToast(
        child: ToastView(
          message: message,
          success: isSccuss,
        ),
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 2),
      );

  void setWaiting() => setState(() {
        _iswaiting = true;
        _saveItOnce = true;
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _formKey,
        child: Stack(
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          children: [
            Opacity(
              opacity: _iswaiting ? 0.5 : 1.0,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const DialogTitle(name: 'إسم المستخدم: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: widget.user.userName ?? '',
                    error: 'قُمْ بإدخال اسم المستخدم',
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    onSave: (value) {
                      widget.user.userName = value;
                    },
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'إسم الشهرة: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: widget.user.knownAs ?? '',
                    error: 'قُمْ بإدخال اللقب',
                    type: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    onSave: (value) {
                      widget.user.knownAs = value;
                    },
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'تاريخ الميلاد: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: widget.user.dateOfBirth ?? 'day - month - year',
                    error: 'قُمْ بإدخال تاريخ الميلاد',
                    type: TextInputType.number,
                    action: TextInputAction.next,
                    onSave: (value) {
                      widget.user.dateOfBirth = value;
                    },
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'المدينة: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: widget.user.city ?? 'Mansoura',
                    error: 'قُمْ بإدخال المدينة',
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    onSave: (value) {
                      widget.user.city = value;
                    },
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'رقم الهاتف: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: widget.user.telephone ?? '00-000-000-000',
                    error: 'قُمْ بإدخال رقم الهاتف',
                    type: TextInputType.phone,
                    action: TextInputAction.done,
                    onSave: (value) {
                      widget.user.telephone = value;
                    },
                  ),
                  const SizedBox(height: 50),
                  RoundedTextButton(
                    text: 'تعديل',
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertView(
                        isSave: true,
                        message: 'هل انت متأكد من حفظ هذا التعديل؟',
                        onpress: () {
                          if (!_iswaiting) setWaiting();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_iswaiting)
              FutureBuilder(
                future: _saveItOnce
                    ? _saveForm()
                    : Future.delayed(const Duration(seconds: 2)),
                builder: (context, snapshot) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Palette.primaryLightColor,
                      color: Palette.primaryColor,
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
