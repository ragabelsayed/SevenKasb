import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/auth.dart';
import '/providers/user_provider.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/alert_view.dart';
import '/widget/rounded_text_btn.dart';
import '/widget/toast_view.dart';

class PasswordFormScreen extends StatefulWidget {
  final FToast fToast;
  const PasswordFormScreen({Key? key, required this.fToast}) : super(key: key);
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
  bool _iswaiting = false;
  bool _saveItOnce = false;

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
      _formKey.currentState!.save();
      if (_controller2.text == _controller3.text) {
        setState(() => _isNotConfirm = false);
        try {
          setState(() => _saveItOnce = false);
          await context.read(updateUserProvider).updatePassword(
                oldPass: _controller1.text,
                newPass: _controller2.text,
                confirmPass: _controller3.text,
              );
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
        setState(() => _isNotConfirm = true);
        setState(() => _iswaiting = false);
      }
    }
    if (!_isValid) {
      setState(() => _iswaiting = false);
    }
  }

  void toast(String message, bool isSccuss) {
    widget.fToast.showToast(
      child: ToastView(
        message: message,
        success: isSccuss,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void setWaiting() => setState(() {
        _iswaiting = true;
        _saveItOnce = true;
      });

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
                hint: 'كلمة السر القديمة',
                error: 'قُمْ بإدخال كلمة السر القديمة',
                type: TextInputType.visiblePassword,
                action: TextInputAction.next,
                controller: _controller1,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hint: 'كلمة السر الجديدة',
                error: 'قُمْ بإدخال كلمة السر الجديدة',
                type: TextInputType.visiblePassword,
                action: TextInputAction.next,
                controller: _controller2,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                hint: 'تأكيد كلمة السر',
                error: 'قُمْ بتأكيد كلمة السر',
                type: TextInputType.visiblePassword,
                action: TextInputAction.done,
                controller: _controller3,
              ),
              if (_isNotConfirm) const SizedBox(height: 15),
              if (_isNotConfirm)
                const Text(
                  'برجاء التأكد من تطابُق كلمة السر الجديد',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 50),
              if (!_iswaiting)
                RoundedTextButton(
                  text: 'تعديل',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertView(
                      isSave: true,
                      message: 'هل أنت مُتأكد من حفظ هذا التعديل؟',
                      onpress: () {
                        setWaiting();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              if (_iswaiting)
                FutureBuilder(
                  future: _saveItOnce
                      ? _saveForm()
                      : Future.delayed(const Duration(seconds: 2)),
                  builder: (context, snapshot) => const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Palette.primaryLightColor,
                      color: Palette.primaryColor,
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
        if (newValue.length < 4) {
          return 'كلمة السر ضعيفة ويجب أن تكون أكبر من 4 حروف';
        }
      },
      onSaved: (newValue) => setState(() => controller.text = newValue ?? ''),
    );
  }
}
