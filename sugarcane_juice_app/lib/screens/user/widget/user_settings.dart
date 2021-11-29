import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/config/palette.dart';
import '/providers/user_provider.dart';
import '/widget/error_view.dart';
import 'user_form.dart';

class UserSettings extends ConsumerWidget {
  final FToast fToast;
  const UserSettings({Key? key, required this.fToast}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    return Scaffold(
      body: user.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            backgroundColor: Palette.primaryLightColor,
            color: Palette.primaryColor,
          ),
        ),
        error: (error, stackTrace) {
          if (error == true) {
            return ErrorView(
              error: error.toString(),
              isExpier: true,
            );
          } else {
            return ErrorView(
              error: error.toString(),
            );
          }
        },
        data: (_user) => UserForm(user: _user, fToast: fToast),
      ),
    );
  }
}
