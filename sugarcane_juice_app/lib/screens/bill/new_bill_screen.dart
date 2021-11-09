import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sugarcane_juice_app/providers/offLine_provider.dart';

import '/config/constants.dart';
import '/config/palette.dart';
import 'widget/bill_input_form.dart';

class NewBillScreen extends StatelessWidget {
  static const routName = '/new_bill';

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast().init(context);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read(billOfflineProvider.notifier).removeCurrentBill();
              Navigator.pop(context);
            },
          ),
        ),
        body: BillInputForm(fToast: fToast),
      ),
    );
  }
}
