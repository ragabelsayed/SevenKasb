import 'package:flutter/material.dart';

class AppConstants {
  // static const kAnimationDuration = Duration(milliseconds: 200);
  static final appBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    // height: 1.5,
  );

  static ShapeBorder appBarBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(20),
    ),
  );

  static const nameError = 'قُمْ بإدخال اسم الصنف رجاءً';
  static const priceError = 'قُمْ بإدخال سعر الصنف رجاءً';
  static const quentityError = 'قُمْ بإدخال الكمية رجاءً';
  static const unitError = 'قُمْ بإدخال وحدة القياس';
  static const extraReasonError = 'قُمْ بإدخال سبب المصروف';
  static const extraCashError = 'قُمْ بإدخال كمية المصروف';

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
