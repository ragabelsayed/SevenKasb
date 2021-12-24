import 'package:flutter/material.dart';
import '/config/palette.dart';

getBanner({
  required BuildContext context,
  required String errorMessage,
}) {
  ScaffoldMessenger.of(context)
    ..clearMaterialBanners()
    ..showMaterialBanner(
      MaterialBanner(
        key: ValueKey(errorMessage),
        content: Text(
          errorMessage.toString(),
          style: Theme.of(context).snackBarTheme.contentTextStyle,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text(
              'إغلاق',
              style: TextStyle(
                color: Palette.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        forceActionsBelow: true,
        backgroundColor: Palette.primaryLightColor,
      ),
    );
}
