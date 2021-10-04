import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/palette.dart';

class NewBillScreen extends StatelessWidget {
  static const routName = '/new_bill';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle:
        //     SystemUiOverlayStyle(statusBarColor: Palette.primaryLightColor),
        title: Text(
          'إضافة فاتورة',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        // leading: MenuWidget(),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
