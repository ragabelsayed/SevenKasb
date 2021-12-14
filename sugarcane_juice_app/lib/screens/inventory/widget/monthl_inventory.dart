import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/models/inventory.dart';

class MonthlyInventory extends StatelessWidget {
  final InventoryType type;
  const MonthlyInventory({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.calendarCheck),
        backgroundColor: Colors.amber,
        onPressed: () {},
      ),
    );
  }
}
