import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/unit.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';
import 'package:sugarcane_juice_app/widget/toast_view.dart';

class InputUnit extends StatefulWidget {
  final FToast toast;
  InputUnit({required this.toast});

  @override
  State<InputUnit> createState() => _InputUnitState();
}

class _InputUnitState extends State<InputUnit> {
  TextEditingController _editingController = TextEditingController();
  String _unitName = '';
  bool _isError = false;
  bool _isPop = false;

  void _saveText() {
    if (_editingController.text.isEmpty) {
      setState(() {
        _isError = !_isError;
      });
    } else {
      context.read(unitProvider).addUnit(Unit(name: _unitName)).catchError(
        (e) {
          widget.toast.removeQueuedCustomToasts();
          widget.toast.showToast(
            child: ToastView(message: e.toString()),
            toastDuration: Duration(seconds: 3),
            gravity: ToastGravity.BOTTOM,
          );
        },
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitle(name: 'اسم الوحدة:'),
            TextField(
              controller: _editingController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              decoration: InputDecoration(
                fillColor: Palette.primaryLightColor,
                filled: true,
                hintText: 'كيلو, طن, عبوة',
                hintMaxLines: 1,
                hintTextDirection: TextDirection.rtl,
                border: AppConstants.border,
                errorBorder: AppConstants.errorBorder,
                focusedBorder: AppConstants.focusedBorder,
              ),
              onChanged: (value) {
                _unitName = value;
                setState(() => _isError = false);
              },
            ),
            if (_isError)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppConstants.unitError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            if (!_isError) const SizedBox(height: 10),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Palette.primaryColor),
                  child: Text('إضافة'),
                  onPressed: () => _saveText(),
                ),
                const SizedBox(width: 10),
                TextButton(
                  child: Text('إلغاء'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
