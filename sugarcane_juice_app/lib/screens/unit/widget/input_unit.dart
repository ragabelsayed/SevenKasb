import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';

class InputUnit extends StatefulWidget {
  @override
  State<InputUnit> createState() => _InputUnitState();
}

class _InputUnitState extends State<InputUnit> {
  TextEditingController _editingController = TextEditingController();
  String _unitName = '';
  bool _isError = false;

  void _saveText() {
    if (_editingController.text.isEmpty) {
      setState(() {
        _isError = !_isError;
      });
    } else {
      print(_unitName);
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
