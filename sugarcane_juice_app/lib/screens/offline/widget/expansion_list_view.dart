import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/providers/extra_provider.dart';

import 'package:sugarcane_juice_app/providers/offLine_provider.dart';
import 'package:sugarcane_juice_app/screens/offline/widget/expansion_view.dart';

import 'package:sugarcane_juice_app/widget/toast_view.dart';

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

  Future<void> sendToServer() async {
    final extra = context.read(extraOfflineProvider);
    if (extra.isNotEmpty) {
      try {
        extra.forEach((e) async {
          await context.read(addExtraExpensesProvider).addExtra(e);
        });
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          widget.ftoast.showToast(
            child: ToastView(
              message: ' تم ارسال المصروفات',
              success: true,
            ),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
          );
        });
        await Future.delayed(const Duration(seconds: 3));
        widget.ftoast.showToast(
          child: ToastView(
            message: ' سيتم المسح من الجهاز',
            success: true,
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );

        await context.read(extraOfflineProvider.notifier).removeExtra();
        setState(() => _isSending = false);
        widget.ftoast.showToast(
          child: ToastView(
            message: ' تم المسح من الجهاز',
            success: true,
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3),
        );
      } catch (e) {
        widget.ftoast.showToast(
          child: ToastView(
            message: 'لم تتم اضافة المصروفات',
            success: false,
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      }
    }
  }

  void setSending() => setState(() => _isSending = true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Consumer(
          builder: (context, watch, child) {
            var extra = watch(extraOfflineProvider);
            return extra.isNotEmpty
                ? ExpansionView(
                    title: 'مصاريف إضافية',
                    subTitle: ':عدد المصاريف المحفوظة',
                    getList: extra,
                    onpress: () {
                      setSending();
                      Navigator.pop(context);
                    },
                  )
                : SizedBox();
          },
        ),
        if (_isSending)
          FutureBuilder(
            future: sendToServer(),
            builder: (context, snapshot) {
              return const CircularProgressIndicator(
                backgroundColor: Palette.primaryLightColor,
                color: Palette.primaryColor,
              );
            },
          ),
      ],
    );
  }
}
