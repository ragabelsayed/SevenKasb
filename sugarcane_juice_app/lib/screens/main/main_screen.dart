import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import '../../widget/menu_widget.dart';

class MainScreen extends StatelessWidget {
  static const routName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle:
        //     SystemUiOverlayStyle(statusBarColor: Palette.primaryLightColor),
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
      ),

      // drawer: AppDrawer(),
    );
  }
}
