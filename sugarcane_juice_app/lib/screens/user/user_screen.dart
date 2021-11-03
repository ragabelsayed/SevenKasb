import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/user_provider.dart';
import '/widget/error_view.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';
import 'widget/user_form.dart';

class UserScreen extends ConsumerWidget {
  static const routName = '/user';
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إعدادات المستخدم',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
      body: user.when(
        loading: () => Center(
          child: const CircularProgressIndicator(color: Colors.green),
        ),
        error: (error, stackTrace) => ErrorView(error: error.toString()),
        data: (_user) => UserForm(user: _user),
      ),
    );
  }
}
