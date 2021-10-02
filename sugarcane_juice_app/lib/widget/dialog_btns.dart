import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/providers/item_provider.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';

class DialogButtons extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final bool idDeleted;
  final Item? deleteItem;
  const DialogButtons({
    required this.name,
    required this.onPressed,
    this.idDeleted = false,
    this.deleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: idDeleted
              ? MediaQuery.of(context).size.width / 4
              : MediaQuery.of(context).size.width / 3,
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
        if (!idDeleted) const SizedBox(width: 5),
        if (idDeleted)
          IconButton(
            splashRadius: 1.0,
            tooltip: 'حذف الصنف',
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(
                    'هل انت متاكد من حذف هذا الصنف؟',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Palette.primaryColor),
                          child: Text('الغاء'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          child: Text('حذف'),
                          onPressed: () {
                            context
                                .read(itemProvider)
                                .deleteItem(item: deleteItem!);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        SizedBox(
          height: 50,
          width: idDeleted
              ? MediaQuery.of(context).size.width / 4
              : MediaQuery.of(context).size.width / 3,
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
