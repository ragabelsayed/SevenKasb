import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/palette.dart';

class RemoveDialog extends StatelessWidget {
  final String message;
  final Function onpress;
  const RemoveDialog({
    required this.message,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        message,
        textAlign: TextAlign.center,
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
              child: Text('حذف'),
              onPressed: () => onpress(),
            ),
          ],
        ),
      ],
    );
  }
}
