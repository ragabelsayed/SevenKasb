import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/providers/extra_provider.dart';
import 'package:sugarcane_juice_app/screens/extra_expenses/widget/extra_data_table_view.dart';
import 'package:sugarcane_juice_app/widget/banner_message.dart';
import 'package:sugarcane_juice_app/widget/error_view.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مصروفات إضافية',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
      body: extraExpenses.when(
        loading: () => const Center(
          child: const CircularProgressIndicator(color: Colors.green),
        ),
        error: (error, stackTrace) => ErrorView(error: error.toString()),
        data: (extraList) {
          var date = DateTime.now();
          var thirtyDaysAgo = date.subtract(const Duration(days: 30));
          var extras = extraList
              .where((extra) => extra.dataTime.isAfter(thirtyDaysAgo))
              .toList();
          // return extras.isNotEmpty
          return extraList.isNotEmpty
              ? ExtraDataTableView(extraList: extraList)
              : const Center(
                  child: ErrorView(error: 'لا يوجد مصروفات إضافية'),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'اضافة مصاريف إضافية',
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () => showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          builder: (ctx) {
            // if (watch(isErrorProvider).state) {
            //   print('ssas');
            //   getBanner(
            //     context: context,
            //     errorMessage:
            //         'لم تتم اضافة المصروف تاكد من الاتصال بالشبكة الصحيحه',
            //   );
            // }
            return InputExtraExpensesForm(
              hasError: (extraExpensesError) {
                // if (extraExpensesError) {
                //   getBanner(
                //     context: context,
                //     errorMessage:
                //         'لم تتم اضافة المصروف تاكد من الاتصال بالشبكة الصحيحه',
                //   );
                // } else {
                //   return;
                // }
              },
            );
          },
        ),
      ),
    );
  }
}
