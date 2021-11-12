import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/alert_view.dart';
import '/widget/rounded_text_btn.dart';
import '/widget/toast_view.dart';

class PasswordFormScreen extends StatefulWidget {
  final FToast fToast;
  const PasswordFormScreen({required this.fToast});
  @override
  _PasswordFormScreenState createState() => _PasswordFormScreenState();
}

class _PasswordFormScreenState extends State<PasswordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPassowrdVisible = true;
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  bool _isNotConfirm = false;

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      if (_controller2.text == _controller3.text) {
        setState(() => _isNotConfirm = false);
        _formKey.currentState!.save();
        try {
          // setState(() => _saveItOnce = false);
          // await context.read(updateUserProvider).updateUser(widget.user);
          // setState(() => _iswaiting = false);
          widget.fToast.showToast(
            child: ToastView(
              message: 'تم التحديث بنجاح',
              success: true,
            ),
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 2),
          );
        } catch (e) {
          widget.fToast.showToast(
            child: ToastView(
              message: 'خطأ! لم يتم التحديث',
              success: false,
            ),
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 2),
          );
          // setState(() => _iswaiting = false);
        }
      } else {
        setState(() => _isNotConfirm = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 5),
              _buildTextFormField(
                hint: 'الباسورد القديم',
                error: 'قُمْ بإدخال الباسورد القديم',
                type: TextInputType.visiblePassword,
                action: TextInputAction.next,
                controller: _controller1,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hint: 'الباسورد الجديد',
                error: 'قُمْ بإدخال الباسورد الجديد',
                type: TextInputType.visiblePassword,
                action: TextInputAction.next,
                controller: _controller2,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hint: 'تأكيد الباسورد',
                error: 'قُمْ بتأكيد الباسورد',
                type: TextInputType.visiblePassword,
                action: TextInputAction.done,
                controller: _controller3,
              ),
              if (_isNotConfirm) const SizedBox(height: 15),
              if (_isNotConfirm)
                Text(
                  'برجأ التأكد من تطابق الباسورد الجديد',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.red),
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
                      _saveForm();
                      // if (!_iswaiting) setWaiting();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String hint,
    required String error,
    required TextEditingController controller,
    required TextInputType type,
    required TextInputAction action,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      textInputAction: action,
      obscureText: _isPassowrdVisible,
      textAlign: TextAlign.center,
      // textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.lock, color: Palette.primaryColor),
        hintText: hint,
        prefixIcon: IconButton(
          icon: _isPassowrdVisible
              ? const Icon(Icons.visibility_off, color: Palette.primaryColor)
              : const Icon(Icons.visibility, color: Palette.primaryColor),
          onPressed: () => setState(
            () => _isPassowrdVisible = !_isPassowrdVisible,
          ),
        ),
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
      onSaved: (newValue) => setState(() => controller.text = newValue ?? ''),
    );
  }
}
