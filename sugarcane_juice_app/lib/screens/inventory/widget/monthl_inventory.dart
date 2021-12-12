import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MonthlyInventory extends StatelessWidget {
  const MonthlyInventory({Key? key}) : super(key: key);

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
