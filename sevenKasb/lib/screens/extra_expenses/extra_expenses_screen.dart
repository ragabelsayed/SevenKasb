import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/providers/extra_provider.dart';
import 'widget/extra_data_table_view.dart';
import '/widget/error_view.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';
import 'widget/input_extra_expenses_form.dart';

class ExtraExpensesScreen extends ConsumerWidget {
  static const routName = '/extra_expenses';
  const ExtraExpensesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final extraExpenses = watch(extraExpensesProvider);
    FToast fToast = FToast().init(context);
    return RefreshIndicator(
      onRefresh: () => context.refresh(extraExpensesProvider),
      color: Palette.primaryColor,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'مصروفات إضافية',
            style: AppConstants.appBarTitle,
          ),
          centerTitle: true,
          backgroundColor: Palette.primaryColor,
          leading: const MenuWidget(),
          shape: AppConstants.appBarBorder,
        ),
        body: extraExpenses.when(
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
          data: (extraList) {
            var date = DateTime.now();
            var thirtyDaysAgo = date.subtract(const Duration(days: 30));
            var extras = extraList
                .where((extra) => extra.dataTime.isAfter(thirtyDaysAgo))
                .toList();
            return extras.isNotEmpty
                ? ExtraDataTableView(extraList: extras)
                : const Center(
                    child: ErrorView(error: 'لا يوجد مصروفات إضافية'),
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'إضافة مصاريف إضافية',
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () => showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            builder: (ctx) {
              return InputExtraExpensesForm(ftoast: fToast);
            },
          ),
        ),
      ),
    );
  }
}
