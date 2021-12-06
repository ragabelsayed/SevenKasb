import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';
import 'widget/purchase_inventory.dart';
import 'widget/sales_inventory.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast().init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الجرد', style: AppConstants.appBarTitle),
          centerTitle: true,
          backgroundColor: Palette.primaryColor,
          leading: const MenuWidget(),
          shape: AppConstants.appBarBorder,
          bottom: const TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            indicatorColor: Colors.amber,
            tabs: [
              Tab(
                text: 'مبيعات',
                icon: FaIcon(FontAwesomeIcons.clipboardList),
              ),
              Tab(
                text: 'مُشتريات',
                icon: FaIcon(FontAwesomeIcons.clipboardList),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SalesInventory(fToast: fToast),
            PurchaseInventory(fToast: fToast),
          ],
        ),
      ),
    );
  }
}
