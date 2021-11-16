import 'package:flutter/material.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';
import 'widget/purchase_bill.dart';
import 'widget/sell_bill.dart';

class BillScreen extends StatelessWidget {
  static const routName = '/bill';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الفواتير',
            style: AppConstants.appBarTitle,
          ),
          centerTitle: true,
          backgroundColor: Palette.primaryColor,
          leading: MenuWidget(),
          shape: AppConstants.appBarBorder,
          bottom: const TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            indicatorColor: Colors.amber,
            // labelColor: Colors.amber,
            tabs: [
              const Tab(
                text: 'بيع',
                icon: Icon(Icons.sell),
              ),
              const Tab(
                text: 'شراء',
                icon: Icon(Icons.receipt),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const SellBill(),
            const PurchaseBill(),
          ],
        ),
      ),
    );
  }
}
