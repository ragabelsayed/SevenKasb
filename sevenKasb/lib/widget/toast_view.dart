import 'package:flutter/material.dart';
import '/config/palette.dart';

class ToastView extends StatelessWidget {
  final String message;
  final bool success;
  const ToastView({Key? key, required this.message, this.success = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        // color: Colors.greenAccent,
        color: Palette.primaryLightColor,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (success) const Icon(Icons.check),
              if (!success)
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              const SizedBox(width: 12.0),
              Text(
                message,
                maxLines: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
