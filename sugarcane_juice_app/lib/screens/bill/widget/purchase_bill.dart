import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/config/palette.dart';
import '/providers/bill_provider.dart';
import '/widget/error_view.dart';
import '../new_bill_screen.dart';
import 'data_table_view.dart';

class PurchaseBill extends ConsumerWidget {
  const PurchaseBill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bills = watch(billProvider);
    return RefreshIndicator(
      onRefresh: () => context.refresh(billProvider),
      color: Palette.primaryColor,
      child: Scaffold(
        body: bills.when(
          loading: () => Center(
            child: const CircularProgressIndicator(color: Colors.green),
          ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          data: (billList) {
            var purchaseList =
                billList.where((bill) => bill.type == 0).toList();
            return purchaseList.isNotEmpty
                ? DataTableView(bills: purchaseList)
                : Center(
                    child: ErrorView(error: 'لا يوجد فواتير شراء'),
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'إضافة فاتورة شراء جديدة',
          child: Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () {
            context.read(isOffLineProvider).state = false;
            Navigator.pushNamed(context, NewBillScreen.routName);
          },
        ),
      ),
    );
  }
}
