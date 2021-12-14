import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/config/palette.dart';
import '/providers/inventory_povider.dart';

class DailyInventory extends StatelessWidget {
  const DailyInventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.calendarDay),
        backgroundColor: Colors.amber,
        onPressed: () async {
          final initalDate = DateTime.now();
          final newDate = await showDatePicker(
            context: context,
            initialDate: initalDate,
            firstDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 61),
            lastDate:
                DateTime(initalDate.year, initalDate.month, initalDate.day),
            // textDirection: TextDirection.rtl,
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: Palette.primaryColor,
                    secondary: Palette.primaryLightColor,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (newDate != null) {
            context
                .read(inventoryProvider.notifier)
                .getInventory(date: newDate, type: 0);
          }
        },
      ),
    );
  }
}
