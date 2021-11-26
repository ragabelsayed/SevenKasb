import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/screens/main/main_screen.dart';
import '/providers/auth.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/rounded_text_btn.dart';

class LoginScreen extends StatefulWidget {
  static const routName = '/log_in';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  bool _isPassowrdVisible = true;
  bool _isError = false;
  String _errorMessage = '';
  Map<String, String> userData = {'name': '', 'password': ''};
  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();
    _emailcontroller.addListener(onListen);
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      try {
        await context
            .read(authProvider.notifier)
            .login(name: userData['name']!, password: userData['password']!);
        setState(() => _isWaiting = false);
        await Navigator.pushNamed(context, MainScreen.routName);
      } catch (e) {
        setState(() {
          _isWaiting = false;
          _isError = !_isError;
          _errorMessage = e.toString();
        });
      }
    } else {
      setState(() => _isWaiting = false);
    }
  }

  @override
  void dispose() {
    _emailcontroller.removeListener(onListen);
    _emailcontroller.dispose();
    super.dispose();
  }

  void onListen() => setState(() {});
  void setWaiting() => setState(() => _isWaiting = !_isWaiting);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.height * 0.15),
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          const AssetImage('assets/images/logo_1.jpg'),
                      radius: size.width * 0.3,
                    ),
                    SizedBox(height: size.height * 0.04),
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextFormField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: Palette.primaryLightColor,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Palette.primaryColor,
                          ),
                          hintText: 'Username',
                          suffixIcon: _emailcontroller.text.isNotEmpty
                              ? IconButton(
                                  splashRadius: 1.0,
                                  tooltip: 'مسح',
                                  icon: const Icon(
                                    Icons.close,
                                    color: Palette.primaryColor,
                                  ),
                                  onPressed: () => _emailcontroller.clear(),
                                )
                              : null,
                          border: AppConstants.border,
                          errorBorder: AppConstants.errorBorder,
                          focusedBorder: AppConstants.focusedBorder,
                        ),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return 'قُمْ بإدخال الإسم رجاءً';
                          }
                        },
                        onSaved: (newValue) => userData['name'] = newValue!,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: _isPassowrdVisible,
                        decoration: InputDecoration(
                          fillColor: Palette.primaryLightColor,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Palette.primaryColor,
                          ),
                          hintText: 'passoword',
                          suffixIcon: IconButton(
                            icon: _isPassowrdVisible
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Palette.primaryColor,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Palette.primaryColor,
                                  ),
                            onPressed: () {
                              setState(
                                () => _isPassowrdVisible = !_isPassowrdVisible,
                              );
                            },
                          ),
                          border: AppConstants.border,
                          errorBorder: AppConstants.errorBorder,
                          focusedBorder: AppConstants.focusedBorder,
                        ),
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return 'قُمْ بإدخال الباسورد رجاءً';
                          }
                          if (newValue.length <= 4) {
                            return 'الباسورد أقل من 4 حروف';
                          }
                        },
                        onSaved: (newValue) => userData['password'] = newValue!,
                      ),
                    ),
                    if (!_isError) SizedBox(height: size.height * 0.03),
                    if (_isError)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(width: 5),
                              Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!_isWaiting)
                      RoundedTextButton(
                        text: 'تسجيل الدخول',
                        onPressed: () => setWaiting(),
                      ),
                    if (_isWaiting)
                      FutureBuilder(
                        future: _saveForm(),
                        builder: (context, snapshot) =>
                            const CircularProgressIndicator(
                          backgroundColor: Palette.primaryLightColor,
                          color: Palette.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
