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
  late TextEditingController _nameController;
  late TextEditingController _asKnownController;
  late TextEditingController _dateController;
  late TextEditingController _cityController;
  late TextEditingController _namberController;

  @override
  void initState() {
    super.initState();
    _user = widget.userData['user'];
    _nameController = TextEditingController(text: _user.userName ?? '');
    _asKnownController = TextEditingController(text: _user.knownAs ?? '');
    _dateController = TextEditingController(
        text: intl.DateFormat.yMd()
            .format(DateTime.parse(_user.dateOfBirth!).year >= 1970
                ? DateTime.parse(_user.dateOfBirth!)
                : DateTime.parse('1970-01-01T00:00:00'))
            .replaceAll(RegExp(r'/'), '-'));
    _cityController = TextEditingController(text: _user.city ?? '');
    _namberController = TextEditingController(text: _user.telephone ?? '');
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
    _user.userName = _nameController.text;
    _user.knownAs = _asKnownController.text;
    _user.dateOfBirth = _dateController.text;
    _user.city = _cityController.text;
    _user.telephone = _namberController.text;
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
    } else {
      setState(() {
        _saveItOnce = false;
        _iswaiting = false;
      });
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
  void dispose() {
    _nameController.dispose();
    _asKnownController.dispose();
    _dateController.dispose();
    _cityController.dispose();
    _namberController.dispose();
    super.dispose();
  }

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
                    error: 'قُمْ بإدخال اسم المستخدم',
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    controller: _nameController,
                    onSave: (value) => _namberController.text = value,
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'إسم الشُهرة: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    error: 'قُمْ بإدخال اللقب',
                    type: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    controller: _asKnownController,
                    onSave: (value) => _asKnownController.text = value,
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'تاريخ الميلاد: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    error: 'قُمْ بإدخال تاريخ الميلاد',
                    type: TextInputType.number,
                    action: TextInputAction.next,
                    readonly: true,
                    controller: _dateController,
                    onSave: (value) {},
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'المدينة: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    error: 'قُمْ بإدخال المدينة',
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    controller: _cityController,
                    onSave: (value) => _cityController.text = value,
                  ),
                  const SizedBox(height: 5),
                  const DialogTitle(name: 'رقم الهاتف: '),
                  const SizedBox(height: 5),
                  _buildTextFormField(
                    error: 'قُمْ بإدخال رقم الهاتف',
                    type: TextInputType.phone,
                    isNamberOnly: true,
                    action: TextInputAction.done,
                    controller: _namberController,
                    onSave: (value) => _namberController.text = value,
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
    required String error,
    required TextInputType type,
    bool isNamberOnly = false,
    required TextInputAction action,
    required Function(String) onSave,
    bool readonly = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      keyboardType: type,
      textInputAction: action,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      readOnly: readonly,
      controller: controller,
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
