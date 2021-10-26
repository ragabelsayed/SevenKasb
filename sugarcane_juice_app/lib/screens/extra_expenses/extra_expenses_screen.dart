import 'package:flutter/material.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';

class ExtraExpensesScreen extends StatelessWidget {
  static const routName = '/extra_expenses';
  const ExtraExpensesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مصروفات إضافية',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
    );
  }
}
