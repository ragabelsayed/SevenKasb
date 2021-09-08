import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/auth.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/rounded_text_btn.dart';

class LoginScreen extends StatefulWidget {
  static const routName = '/log_in';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = TextEditingController();
  bool _isPassowrdVisible = true;
  bool _errorMessage = false;
  Map<String, String> userData = {'name': 'khaled', 'password': 'khaled'};

  @override
  void initState() {
    super.initState();
    _emailcontroller.addListener(onListen);
  }

  void _saveForm() async {
    final _isValid = _formKey.currentState!.validate();

    if (_isValid) {
      _formKey.currentState!.save();

      context
          .read(authProvider)
          .login(name: userData['name']!, password: userData['password']!)
          .onError(
        (error, stackTrace) {
          return setState(() {
            _errorMessage = !_errorMessage;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _emailcontroller.removeListener(onListen);
    _emailcontroller.dispose();
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                              tooltip: 'Clear',
                              icon: Icon(
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
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: (newValue) {
                      if (newValue!.isEmpty) {
                        return 'Please enter your name or email';
                      }
                    },
                    onSaved: (newValue) {
                      userData['name'] = newValue!;
                    },
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
                            ? Icon(
                                Icons.visibility_off,
                                color: Palette.primaryColor,
                              )
                            : Icon(
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
                        return 'Please enter your password';
                      }
                      // if (newValue.length < 7) {
                      //   return 'Passoword is wrong';
                      // }
                    },
                    onSaved: (newValue) {
                      userData['password'] = newValue!;
                    },
                  ),
                ),
                if (!_errorMessage) SizedBox(height: size.height * 0.03),
                if (_errorMessage)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'The name or password not correct',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                RoundedTextButton(
                  text: 'LOGIN',
                  onPressed: _saveForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
