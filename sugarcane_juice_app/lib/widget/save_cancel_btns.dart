import 'package:flutter/material.dart';
import '/config/palette.dart';

class SaveAndCancelBtns extends StatelessWidget {
  final Function onSave;
  const SaveAndCancelBtns({Key? key, required this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          // width: MediaQuery.of(context).size.width / 3,
          width: MediaQuery.of(context).size.width / 3.5,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Palette.primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                  ),
                )),
            child: const Text('إلغاء'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          height: 50,
          // width: MediaQuery.of(context).size.width / 3,
          width: MediaQuery.of(context).size.width / 3.5,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Palette.primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                ),
              ),
            ),
            child: const Text('حفظ'),
            onPressed: () => onSave(),
          ),
        ),
      ],
    );
  }
}
