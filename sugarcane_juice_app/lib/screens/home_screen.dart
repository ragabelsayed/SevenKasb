import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:sugarcane_juice_app/config/routes.dart';
import 'package:sugarcane_juice_app/screens/bill/bill_screen.dart';
import 'package:sugarcane_juice_app/screens/extra_expenses/extra_expenses_screen.dart';
import 'package:sugarcane_juice_app/screens/item/item_screen.dart';
import 'package:sugarcane_juice_app/screens/menu/menu_screen.dart';
import 'package:sugarcane_juice_app/screens/offline/offline_screen.dart';
import 'package:sugarcane_juice_app/screens/unit/unit_screen.dart';
import 'package:sugarcane_juice_app/screens/user/user_screen.dart';

import 'item/item_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MenuItem currentItem;

  @override
  void initState() {
    super.initState();
    currentItem = MenuItems.bills;
  }

  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        currentItem = watch(menuItemProvider);
        return ZoomDrawer(
          style: DrawerStyle.Style1,
          // angle: -10,
          borderRadius: 30,
          slideWidth: MediaQuery.of(context).size.width * 0.7,
          showShadow: true,
          backgroundColor: Colors.amberAccent,
          // isRtl: true,
          mainScreen: _getScreen(),
          menuScreen: MenuScreen(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() => currentItem = item);

              // ZoomDrawer.of(context)!.close();
            },
          ),
        );
      },
    );
  }

  Widget _getScreen() {
    switch (currentItem) {
      case MenuItems.item:
        return ItemScreen();
      case MenuItems.bills:
        return BillScreen();
      case MenuItems.unit:
        return UnitScreen();
      case MenuItems.extra:
        return ExtraExpensesScreen();
      case MenuItems.offline:
        return OfflineScreen();
      case MenuItems.edit:
        return UserScreen();
      default:
        return ItemScreen();
    }
  }
}
