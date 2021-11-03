import 'package:flutter/material.dart';
import '/config/palette.dart';

class AlertView extends StatelessWidget {
  final bool isSave;
  final String message;
  final Function onpress;
  const AlertView({
    this.isSave = false,
    required this.message,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        message,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
      actions: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Palette.primaryColor),
              child: Text('الغاء'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 10),
            TextButton(
              child: Text(
                !isSave ? 'حذف' : 'حفظ',
                textDirection: TextDirection.rtl,
              ),
              onPressed: () => onpress(),
            ),
          ],
        ),
      ],
    );
  }
}