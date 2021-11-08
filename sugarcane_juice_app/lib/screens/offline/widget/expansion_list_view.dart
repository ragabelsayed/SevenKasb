import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _isSending = false;

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
        setState(() => _isSending = false);
        _toast(' تم المسح من الجهاز', true);
      } catch (e) {
        setState(() => _isSending = false);
        _toast('لم يتم ارسال المصروفات', false);
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

  void setSending() => setState(() => _isSending = true);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var extra = watch(extraOfflineProvider);
        return Column(
          children: [
            SizedBox(height: 5),
            if (extra.isNotEmpty)
              ExpansionView(
                title: 'مصاريف إضافية',
                subTitle: ':عدد المصاريف المحفوظة',
                getList: extra,
                isSending: _isSending,
                sendToServer: () => sendExtraToServer(),
                onpress: () {
                  setSending();
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }
}
