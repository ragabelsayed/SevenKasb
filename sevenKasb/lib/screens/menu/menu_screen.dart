import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/providers/auth.dart';
import '/config/palette.dart';

class MenuItems {
  static const bills =
      MenuItem('الفواتير', FaIcon(FontAwesomeIcons.receipt, size: 28));
  static const extra =
      MenuItem('مصروفات إضافية', FaIcon(FontAwesomeIcons.wallet, size: 25));
  static const inventory =
      MenuItem('الجرد', FaIcon(FontAwesomeIcons.clipboardList, size: 28));
  static const offline = MenuItem('أوف لاين', Icon(Icons.wifi_off, size: 30));
  static const edit =
      MenuItem('الإعدادات', FaIcon(FontAwesomeIcons.userEdit, size: 28));

  static const all = [
    bills,
    extra,
    inventory,
    offline,
    edit,
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
  const MenuScreen(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 18),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundImage: const AssetImage('assets/images/logo_1.jpg'),
              radius: MediaQuery.of(context).size.width * 0.13,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'سڤن قصب',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white),
            ),
          ),
          const Divider(color: Colors.amber),
          const SizedBox(height: 10),
          ...MenuItems.all.map((e) => _buildMenuItem(e)).toList(),
          const Spacer(flex: 4),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 30),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: const StadiumBorder(),
                backgroundColor: Colors.green,
                primary: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              icon: const FaIcon(FontAwesomeIcons.signOutAlt),
              label: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
              onPressed: () =>
                  context.read(authProvider.notifier).logOut(context),
            ),
          ),
        ],
      ),
    );
  }

  ListTileTheme _buildMenuItem(MenuItem item) => ListTileTheme(
        selectedColor: Palette.primaryColor,
        iconColor: Colors.white,
        textColor: Colors.white,
        child: ListTile(
          selected: currentItem == item,
          selectedTileColor: Palette.primaryLightColor,
          leading: item.iconData,
          title: Text(
            item.title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          ),
          onTap: () => onSelectedItem(item),
        ),
      );
}
