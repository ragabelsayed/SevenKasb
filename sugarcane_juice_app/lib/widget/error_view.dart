import 'package:flutter/material.dart';
import '/config/palette.dart';

class ErrorView extends StatelessWidget {
  final String error;
  const ErrorView({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          height: 100,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Palette.primaryLightColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.amberAccent.withOpacity(0.6),
                blurRadius: 17,
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
