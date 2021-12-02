import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/providers/user_provider.dart';
import 'user_form.dart';

class UserSettings extends StatefulWidget {
  final FToast fToast;
  const UserSettings({Key? key, required this.fToast}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  void initState() {
    super.initState();
    context.read(userProvider.notifier).fetchUserDate();
  }

  @override
  Widget build(BuildContext context) {
    // final user = watch(userProvider);
    return Consumer(
      builder: (context, watch, child) {
        final userData = watch(userProvider);
        return Scaffold(
          body: UserForm(userData: userData, fToast: widget.fToast),
          // body: user.when(
          //   loading: () => const Center(
          //     child: CircularProgressIndicator(
          //       backgroundColor: Palette.primaryLightColor,
          //       color: Palette.primaryColor,
          //     ),
          //   ),
          //   error: (error, stackTrace) {
          //     if (error == true) {
          //       return ErrorView(
          //         error: error.toString(),
          //         isExpier: true,
          //       );
          //     } else {
          //       return ErrorView(
          //         error: error.toString(),
          //       );
          //     }
          //   },
          //   data: (_user) => UserForm(user: _user, fToast: fToast),
          // ),
        );
      },
    );
  }
}
