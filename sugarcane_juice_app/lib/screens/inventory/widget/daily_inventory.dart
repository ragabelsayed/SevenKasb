import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DailyInventory extends StatelessWidget {
  const DailyInventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.calendarDay),
        backgroundColor: Colors.amber,
        onPressed: () {},
      ),
    );
  }
}
