import 'package:flutter/material.dart';

class AppConstants {
  // static const kAnimationDuration = Duration(milliseconds: 200);

  // static final headingStyle = TextStyle(
  //   fontSize: SizeConfig.getProportionateScreentWidth(28),
  //   fontWeight: FontWeight.bold,
  //   color: Colors.black,
  //   height: 1.5,
  // );

  static const nameError = 'قُمْ بإدخال اسم الصنف رجاءً';
  static const priceError = 'قُمْ بإدخال سعر الصنف رجاءً';
  static const quentityError = 'قُمْ بإدخال الكمية رجاءً';
  static const unitError = 'قُمْ بإدخال وحدة القياس';

  static OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(50.0),
  );
  static UnderlineInputBorder errorBorder = UnderlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.red,
      width: 3.0,
    ),
    borderRadius: BorderRadius.circular(50.0),
  );
  static UnderlineInputBorder focusedBorder = UnderlineInputBorder(
    borderSide: const BorderSide(
      // color: kPrimaryColor,
      width: 3.0,
    ),
    borderRadius: BorderRadius.circular(50.0),
  );
}
