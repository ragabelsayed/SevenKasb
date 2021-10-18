import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/palette.dart';

getBanner({
  required BuildContext context,
  required String errorMessage,
}) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: Text(
        errorMessage.toString(),
        style: Theme.of(context).snackBarTheme.contentTextStyle,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).clearMaterialBanners(),
          child: Text(
            'إغلاق',
            style: TextStyle(
              color: Palette.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      leading: Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
      forceActionsBelow: true,
      backgroundColor: Palette.primaryLightColor,
    ),
  );
}