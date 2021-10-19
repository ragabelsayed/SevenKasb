import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/config/palette.dart';
import '/models/unit.dart';
import '/providers/unit_provider.dart';
import '/widget/dialog_remove.dart';
import '/widget/dialog_title.dart';
import '/widget/toast_view.dart';

class UnitView extends StatelessWidget {
  final Unit unit;
  final FToast toast;
  const UnitView({required this.unit, required this.toast});

  @override
  Widget build(BuildContext context) {
    bool _hasError = false;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Palette.primaryLightColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            offset: const Offset(1.0, 2.0),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: DialogTitle(name: unit.name),
        leading: IconButton(
          splashRadius: 1.0,
          tooltip: 'حذف هذه الوحدة',
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => RemoveDialog(
                message: 'هل انت متاكد من حذف هذة الوحدة؟',
                onpress: () {
                  context.read(unitProvider).deleteUnit(unit: unit).catchError(
                    (e) {
                      _hasError = !_hasError;
                      toast
                        ..removeQueuedCustomToasts()
                        ..showToast(
                          child: ToastView(message: e.toString()),
                          toastDuration: Duration(seconds: 3),
                          gravity: ToastGravity.BOTTOM,
                        );
                    },
                  ).whenComplete(
                    () {
                      if (!_hasError) {
                        return toast
                          ..removeQueuedCustomToasts()
                          ..showToast(
                            child: ToastView(message: 'تم الحذف بنجاح'),
                            toastDuration: Duration(seconds: 3),
                            gravity: ToastGravity.BOTTOM,
                          );
                      }
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
