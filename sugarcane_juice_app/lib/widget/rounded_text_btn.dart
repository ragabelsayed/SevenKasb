import 'package:flutter/material.dart';
import '/config/palette.dart';

class RoundedTextButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color primaryColor;
  final Function onPressed;
  const RoundedTextButton({
    Key? key,
    required this.text,
    this.backgroundColor = Palette.primaryColor,
    this.primaryColor = Colors.white,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextButton(
      child: Text(text),
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        primary: primaryColor,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 18),
        fixedSize: Size(size.width * 0.8, size.height * 0.07),
      ),
      onPressed: () => onPressed(),
    );
  }
}
