import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/providers/bill_provider.dart';
import '/providers/offLine_provider.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import 'widget/bill_input_form.dart';

class NewBillScreen extends StatelessWidget {
  static const routName = '/new_bill';

  const NewBillScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast().init(context);
    var _isOffLine = context.read(isOffLineProvider).state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.primaryColor,
          title: const Text(
            'إضافة فاتورة',
            style: AppConstants.appBarTitle,
          ),
          centerTitle: true,
          shape: AppConstants.appBarBorder,
          leading: _isOffLine
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context
                        .read(billOfflineProvider.notifier)
                        .removeCurrentBill();
                    Navigator.pop(context);
                  },
                )
              : null,
        ),
        body: BillInputForm(fToast: fToast),
      ),
    );
  }
}
