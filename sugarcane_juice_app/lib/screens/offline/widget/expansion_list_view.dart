import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/models/bill_item.dart';
import 'package:sugarcane_juice_app/providers/bill_provider.dart';
import 'package:sugarcane_juice_app/providers/item_provider.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';
import '/models/extra_expenses.dart';
import '/providers/extra_provider.dart';
import '/providers/offLine_provider.dart';
import '/screens/offline/widget/expansion_view.dart';
import '/widget/toast_view.dart';

class ExpansionListView extends StatefulWidget {
  final FToast ftoast;
  const ExpansionListView({
    Key? key,
    required this.ftoast,
  }) : super(key: key);
  @override
  State<ExpansionListView> createState() => _ExpansionListViewState();
}

class _ExpansionListViewState extends State<ExpansionListView> {
  bool _isSending1 = false;
  bool _isSending2 = false;

  Future<void> sendExtraToServer() async {
    final extra = context.read(extraOfflineProvider);
    if (extra.isNotEmpty) {
      try {
        await Future.forEach(extra, (Extra e) async {
          await context.read(addExtraExpensesProvider).addExtra(e);
        });
        _toast(' تم ارسال المصروفات', true);
        _toast(' سيتم المسح من الجهاز', true);
        await context.read(extraOfflineProvider.notifier).removeExtra();
        setState(() => _isSending1 = false);
        _toast(' تم المسح من الجهاز', true);
      } catch (e) {
        setState(() => _isSending1 = false);
        _toast('لم يتم ارسال المصروفات', false);
      }
    }
  }

  Future<void> sendBillToServer() async {
    final bills = context.read(billOfflineProvider);
    if (bills.isNotEmpty) {
      try {
        await Future.forEach(bills, (Bill bill) async {
          await Future.forEach(bill.offlineBillItems!,
              (BillItems billItem) async {
            final newUnit =
                await context.read(unitProvider).addUnit(billItem.item.unit);
            billItem.item.unit = newUnit;

            final newItem =
                await context.read(itemProvider).addItem(billItem.item);
            billItem.item = newItem;
            await billItem.save();
          });
          print(2222);
          await bill.save();
          await context.read(addBillProvider).addBill(bill, true);
        });

        _toast(' تم ارسال الفواتير', true);
        _toast(' سيتم الحذف من الجهاز', true);
        await context.read(billOfflineProvider.notifier).removeBills();
        setState(() => _isSending2 = false);
        _toast(' تم الحذف من الجهاز', true);
      } catch (e) {
        setState(() => _isSending2 = false);
        _toast('لم يتم ارسال الفواتير', false);
      }
    }
  }

  void _toast(String masseg, bool succes) {
    widget.ftoast.showToast(
      child: ToastView(
        message: masseg,
        success: succes,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void setSending1() => setState(() => _isSending1 = true);
  void setSending2() => setState(() => _isSending2 = true);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var extra = watch(extraOfflineProvider);
        var bills = watch(billOfflineProvider);
        return Column(
          children: [
            SizedBox(height: 5),
            if (extra.isNotEmpty)
              ExpansionView(
                title: 'مصاريف إضافية',
                subTitle: ':عدد المصاريف المحفوظة',
                getList: extra,
                isSending: _isSending1,
                sendToServer: () => sendExtraToServer(),
                onpress: () {
                  setSending1();
                  Navigator.pop(context);
                },
              ),
            SizedBox(height: 5),
            if (bills.isNotEmpty)
              ExpansionView(
                title: 'فواتير شراء',
                subTitle: ':عدد الفواتير المحفوظة',
                getList: bills,
                isSending: _isSending2,
                sendToServer: () => sendBillToServer(),
                onpress: () {
                  setSending2();
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }
}
