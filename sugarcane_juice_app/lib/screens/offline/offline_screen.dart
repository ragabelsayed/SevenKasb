import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';
import 'widget/linear_flow.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أوف لاين',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
      floatingActionButton: LinearFlowWidget(fToast: fToast),
    );
  }
}
