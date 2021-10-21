import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/bill_provider.dart';
import 'data_table_view.dart';
import '/widget/error_view.dart';

class SellBill extends ConsumerWidget {
  const SellBill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bills = watch(billProvider);
    return Scaffold(
      body: bills.when(
        loading: () => Center(
          child: const CircularProgressIndicator(color: Colors.green),
        ),
        error: (error, stackTrace) => ErrorView(error: error.toString()),
        data: (billList) {
          var sellList = billList.where((bill) => bill.type == 1).toList();
          return sellList.isNotEmpty
              ? DataTableView(bills: sellList)
              : Center(
                  child: ErrorView(error: 'لا يوجد فواتير بيع'),
                );
        },
      ),
    );
  }
}
