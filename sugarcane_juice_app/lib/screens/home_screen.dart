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

class HomeScreen extends ConsumerWidget {
  static const routName = '/home';

  Widget build(BuildContext context, ScopedReader watch) {
    ItemNotifier itemNotifier = watch(menuItemProvider.notifier);
    var currentItem = watch(menuItemProvider);
    return ZoomDrawer(
      style: DrawerStyle.Style1,
      // angle: -10,
      borderRadius: 30,
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      showShadow: true,
      backgroundColor: Colors.amberAccent,
      // isRtl: true,
      mainScreen: itemNotifier.getScreen(),
      menuScreen: MenuScreen(
        currentItem: currentItem,
        onSelectedItem: (item) {
          context.read(menuItemProvider.notifier).setItem(item);
          // ZoomDrawer.of(context)!.close();
        },
      ),
    );
  }
}
