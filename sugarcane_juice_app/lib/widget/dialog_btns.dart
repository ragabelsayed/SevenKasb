import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/palette.dart';

class DialogButtons extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  const DialogButtons({
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Palette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                  ),
                )),
            child: Text('غلق'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Palette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                )),
            child: Text('$name'),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
