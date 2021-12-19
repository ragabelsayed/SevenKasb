import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
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
  final Map<String, dynamic> userData;
  final FToast fToast;
  const UserForm({Key? key, required this.userData, required this.fToast})
      : super(key: key);
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _iswaiting = false;
  bool _saveItOnce = false;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.userData['user'];
    Future.delayed(Duration.zero, () {
      widget.fToast.showToast(
        child: ToastView(
          message: widget.userData['message'],
          success: true,
        ),
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 3),
      );
    });
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      try {
        setState(() => _saveItOnce = false);
        await context.read(userProvider.notifier).updateUser(_user);
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
                  const DialogTitle(name: 'إسم المُستخدم: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: _user.userName ?? '',
                    error: 'قُمْ بإدخال اسم المستخدم',
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    onSave: (value) => _user.userName = value,
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'إسم الشُهرة: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: _user.knownAs ?? '',
                    error: 'قُمْ بإدخال اللقب',
                    type: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    onSave: (value) => _user.knownAs = value,
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'تاريخ الميلاد: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: intl.DateFormat.yMd()
                        .format(DateTime.parse(_user.dateOfBirth!).year >= 1970
                            ? DateTime.parse(_user.dateOfBirth!)
                            : DateTime.parse('1970-01-01T00:00:00'))
                        .replaceAll(RegExp(r'/'), '-'),
                    error: 'قُمْ بإدخال تاريخ الميلاد',
                    type: TextInputType.number,
                    action: TextInputAction.next,
                    readonly: true,
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'المدينة: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: _user.city ?? 'Mansoura',
                    error: 'قُمْ بإدخال المدينة',
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    onSave: (value) => _user.city = value,
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'رقم الهاتف: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    initValue: _user.telephone ?? '',
                    error: 'قُمْ بإدخال رقم الهاتف',
                    type: TextInputType.phone,
                    isNamberOnly: true,
                    action: TextInputAction.done,
                    onSave: (value) => _user.telephone = value,
                  ),
                  const SizedBox(height: 50),
                  RoundedTextButton(
                      text: 'تعديل',
                      backgroundColor: widget.userData['isUpdated']
                          ? Palette.primaryColor
                          : Colors.grey.shade400,
                      onPressed: () {
                        if (widget.userData['isUpdated']) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertView(
                              isSave: true,
                              message: 'هل أنت مُتأكد من حفظ هذا التعديل؟',
                              onpress: () {
                                if (!_iswaiting) setWaiting();
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        } else {
                          toast('أنت غير مُتصل بالشبكة', false);
                        }
                      }),
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
    bool isNamberOnly = false,
    required TextInputAction action,
    Function(String)? onSave,
    bool readonly = false,
  }) {
    return TextFormField(
      keyboardType: type,
      textInputAction: action,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      readOnly: readonly,
      inputFormatters: isNamberOnly
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
          : null,
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
      onSaved: (newValue) => onSave!(newValue!),
    );
  }
}
