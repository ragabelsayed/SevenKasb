import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/models/inventory.dart';
import '/config/palette.dart';
import '/providers/inventory_povider.dart';

class DailyInventory extends StatelessWidget {
  final InventoryType type;
  const DailyInventory({Key? key, required this.type}) : super(key: key);

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
            if (InventoryType.purchase == type) {
              context
                  .read(inventoryPurchasesProvider.notifier)
                  .getInventory(date: newDate, type: 0);
            }
            if (InventoryType.sales == type) {
              context
                  .read(inventorySalesProvider.notifier)
                  .getInventory(date: newDate, type: 1);
            }
          }
        },
      ),
    );
  }
}
