import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';
import 'widget/password_form_screen.dart';
import 'widget/user_settings.dart';

class UserScreen extends StatelessWidget {
  static const routName = '/user';
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast().init(context);
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'إعدادات المستخدم',
              style: AppConstants.appBarTitle,
            ),
            centerTitle: true,
            backgroundColor: Palette.primaryColor,
            leading: MenuWidget(),
            shape: AppConstants.appBarBorder,
            bottom: TabBar(
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              indicatorColor: Colors.amber,
              tabs: [
                const Tab(
                  text: 'الأدمن',
                  icon: const FaIcon(FontAwesomeIcons.userEdit),
                ),
                const Tab(
                  text: 'الباسورد',
                  icon: const FaIcon(FontAwesomeIcons.lock),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UserSettings(fToast: fToast),
              PasswordFormScreen(fToast: fToast),
            ],
          ),
        ),
      ),
    );
  }
}
