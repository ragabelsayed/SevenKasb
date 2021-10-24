import 'package:flutter/material.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import 'widget/bill_input_form.dart';

class NewBillScreen extends StatelessWidget {
  static const routName = '/new_bill';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.primaryColor,
          title: Text(
            'إضافة فاتورة',
            style: AppConstants.appBarTitle,
          ),
          centerTitle: true,
          shape: AppConstants.appBarBorder,
        ),
        body: BillInputForm(),
      ),
    );
  }
}
