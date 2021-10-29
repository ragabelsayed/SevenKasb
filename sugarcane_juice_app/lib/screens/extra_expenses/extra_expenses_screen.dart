import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/screens/extra_expenses/widget/input_extra_expenses_form.dart';
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
      body: SizedBox(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'اضافة مصاريف إضافية',
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () => showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          builder: (ctx) => InputExtraExpensesForm(
            hasError: (extraExpensesError) {},
          ),
        ),
      ),
    );
  }
}
