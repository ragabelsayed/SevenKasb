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
    return Consumer(
      builder: (context, watch, child) {
        final userData = watch(userProvider);
        return Scaffold(
          body: UserForm(userData: userData, fToast: widget.fToast),
        );
      },
    );
  }
}
