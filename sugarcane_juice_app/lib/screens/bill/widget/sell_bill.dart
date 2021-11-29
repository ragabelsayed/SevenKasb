import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/config/palette.dart';
import '/providers/bill_provider.dart';
import 'data_table_view.dart';
import '/widget/error_view.dart';

class SellBill extends ConsumerWidget {
  const SellBill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bills = watch(billProvider);
    return RefreshIndicator(
      onRefresh: () => context.refresh(billProvider),
      color: Palette.primaryColor,
      child: Scaffold(
        body: bills.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.green),
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
            var sellList = billList.where((bill) => bill.type == 1).toList();
            return sellList.isNotEmpty
                ? DataTableView(bills: sellList)
                : const Center(
                    child: ErrorView(error: 'لا يوجد فواتير بيع'),
                  );
          },
        ),
      ),
    );
  }
}
