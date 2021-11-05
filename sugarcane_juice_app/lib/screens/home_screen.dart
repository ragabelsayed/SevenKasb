import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '/config/routes.dart';
import 'menu/menu_screen.dart';

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
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.fastOutSlowIn,
      backgroundColor: Colors.amberAccent,
      // isRtl: true,
      mainScreen: itemNotifier.getScreen(),
      menuScreen: Builder(
        builder: (context) => MenuScreen(
          currentItem: currentItem,
          onSelectedItem: (item) {
            context.read(menuItemProvider.notifier).setItem(item);
            ZoomDrawer.of(context)!.close();
          },
        ),
      ),
    );
  }
}
