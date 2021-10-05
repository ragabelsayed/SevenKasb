import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sugarcane_juice_app/providers/auth.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';
import '/config/palette.dart';

class MenuItems {
  static const item = MenuItem('الاصناف', FaIcon(FontAwesomeIcons.home));
  static const bills = MenuItem('الفواتير', FaIcon(FontAwesomeIcons.receipt));
  static const stock = MenuItem('Stock', FaIcon(FontAwesomeIcons.warehouse));
  static const help = MenuItem('Help', FaIcon(FontAwesomeIcons.handsHelping));
  static const aboutUs =
      MenuItem('About Us', FaIcon(FontAwesomeIcons.infoCircle));
  static const unit =
      MenuItem('وحدة القياس', FaIcon(FontAwesomeIcons.balanceScale));

  static const all = [
    item,
    bills,
    stock,
    help,
    aboutUs,
    unit,
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
          // textDirection: TextDirection.rtl,
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
                label: Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                onPressed: () {
                  print('out 1');
                  context.read(authProvider).logOut();
                  print('out 2');
                },
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
          // trailing: item.iconData,
          title:
              //  DialogTitle(name: item.title),
              Text(
            item.title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            // textDirection: TextDirection.rtl,
          ),
          onTap: () {
            onSelectedItem(item);
          },
        ),
      );
}
