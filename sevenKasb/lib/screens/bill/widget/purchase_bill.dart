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
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Palette.primaryColor,
              backgroundColor: Palette.primaryLightColor,
            ),
          ),
          error: (error, stackTrace) {
            if (error == true) {
              return ErrorView(
                error: error.toString(),
                isExpier: true,
              );
            } else {
              return ErrorView(
                error: error.toString(),
              );
            }
          },
          data: (billList) {
            var purchaseList =
                billList.where((bill) => bill.type == 0).toList();
            return purchaseList.isNotEmpty
                ? DataTableView(bills: purchaseList)
                : const Center(
                    child: ErrorView(error: 'لا يُوجد فواتير شراء'),
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'إضافة فاتورة شراء جديدة',
          child: const Icon(Icons.add),
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
