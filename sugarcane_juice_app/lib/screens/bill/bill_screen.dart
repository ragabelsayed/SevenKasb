import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/screens/bill/new_bill_screen.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/bill_view.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/data_table_view.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/purchase_bill.dart';
import 'package:sugarcane_juice_app/screens/bill/widget/sell_bill.dart';
import 'package:sugarcane_juice_app/widget/banner_message.dart';
import 'package:sugarcane_juice_app/widget/error_view.dart';
import 'package:sugarcane_juice_app/widget/menu_widget.dart';
import 'package:sugarcane_juice_app/widget/toast_view.dart';

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
          bottom: TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            indicatorColor: Colors.amber,
            // labelColor: Colors.amber,
            tabs: [
              Tab(
                text: 'بيع',
                icon: Icon(Icons.sell),
              ),
              Tab(
                text: 'شراء',
                icon: Icon(Icons.receipt),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SellBill(),
            PurchaseBill(),
          ],
        ),
        //  FutureBuilder(
        //   future: context.read(billProvider).fetchAndSetData().catchError(
        //         (e) => getBanner(context: context, errorMessage: e.toString()),
        //       ),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: CircularProgressIndicator());
        //     } else {
        //       return Consumer(
        //         builder: (context, watch, child) {
        //           final billList = watch(billProvider).items;
        //           return _buildDataTable(billList: billList, context: context);
        //         },
        //       );
        //     }
        //   },
        // ),
      ),
    );
  }
}
