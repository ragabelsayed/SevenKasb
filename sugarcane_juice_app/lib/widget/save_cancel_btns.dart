import 'package:flutter/material.dart';
import '/config/palette.dart';

class SaveAndCancelBtns extends StatelessWidget {
  final Function onSave;
  const SaveAndCancelBtns({required this.onSave});

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
            child: Text('إلغاء'),
            onPressed: () {
              Navigator.of(context).pop();
            },
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
            child: Text('حفظ'),
            onPressed: () => onSave(),
          ),
        ),
      ],
    );
  }
}
