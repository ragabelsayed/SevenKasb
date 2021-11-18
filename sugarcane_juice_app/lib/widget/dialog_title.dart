import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  final String? name;
  const DialogTitle({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: name,
        style: Theme.of(context)
            .textTheme
            .merge(
              const TextTheme(
                headline6: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
            .headline6,
      ),
      textDirection: TextDirection.rtl,
    );
  }
}
