import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الجرد',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: const MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
    );
  }
}
