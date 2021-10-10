import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/palette.dart';

class RoundedTextButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color primaryColor;
  final Function onPressed;
  const RoundedTextButton({
    required this.text,
    this.backgroundColor = Palette.primaryColor,
    this.primaryColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextButton(
      child: Text(text),
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        primary: primaryColor,
        shape: const StadiumBorder(),
        fixedSize: Size(size.width * 0.8, size.height * 0.07),
      ),
      onPressed: () => onPressed(),
    );
  }
}
