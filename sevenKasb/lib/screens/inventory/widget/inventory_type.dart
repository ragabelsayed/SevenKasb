import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/models/inventory.dart' as t;
import '/config/constants.dart';
import '/config/palette.dart';
import 'daily_inventory.dart';
import 'monthl_inventory.dart';

class InventoryType extends StatelessWidget {
  final t.InventoryType type;
  final FToast fToast;
  const InventoryType({Key? key, required this.type, required this.fToast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          backgroundColor: Palette.primaryColor,
          shape: AppConstants.appBarBorder,
          bottom: const TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            indicatorColor: Colors.amber,
            tabs: [
              Tab(
                text: 'شهري',
              ),
              Tab(
                text: 'يومى',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MonthlyInventory(type: type),
            DailyInventory(type: type),
          ],
        ),
      ),
    );
  }
}
