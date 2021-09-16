import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/config/palette.dart';

class MenuItems {
  static const home = MenuItem('Home', FaIcon(FontAwesomeIcons.home));
  static const bills = MenuItem('Bill', FaIcon(FontAwesomeIcons.moneyBill));
  static const notification =
      MenuItem('Notification', FaIcon(FontAwesomeIcons.solidStickyNote));
  static const help = MenuItem('Help', FaIcon(FontAwesomeIcons.handsHelping));
  static const aboutUs =
      MenuItem('About Us', FaIcon(FontAwesomeIcons.infoCircle));
  static const rateUs = MenuItem('Rate Us', FaIcon(FontAwesomeIcons.star));

  static const all = [
    home,
    bills,
    notification,
    help,
    aboutUs,
    rateUs,
  ];
}

class MenuItem {
  final String title;
  final Widget iconData;
  const MenuItem(this.title, this.iconData);
}

class MenuScreen extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  const MenuScreen({required this.currentItem, required this.onSelectedItem});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            ...MenuItems.all.map((e) => _buildMenuItem(e)).toList(),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 30),
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: StadiumBorder(),
                  backgroundColor: Colors.green,
                  primary: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                icon: FaIcon(FontAwesomeIcons.signOutAlt),
                // Icon(Icons.exit_to_app),
                label: Text('LogOut'),
                onPressed: () {},
              ),
            ),
            // Spacer()
          ],
        ),
      ),
    );
  }

  ListTileTheme _buildMenuItem(MenuItem item) => ListTileTheme(
        selectedColor: Palette.primaryColor,
        iconColor: Colors.white,
        textColor: Colors.white,
        child: ListTile(
          selected: currentItem == item,
          // minLeadingWidth: 20,
          selectedTileColor: Palette.primaryLightColor,
          leading: item.iconData,
          title: Text(item.title),
          onTap: () {
            onSelectedItem(item);
          },
        ),
      );
}
