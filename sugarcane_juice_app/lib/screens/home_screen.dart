import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:sugarcane_juice_app/screens/bill_screen.dart';
import 'package:sugarcane_juice_app/screens/main/main_screen.dart';
import 'package:sugarcane_juice_app/screens/menu/menu_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MenuItem currentItem = MenuItems.home;

  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style1,
      // angle: -10,
      borderRadius: 30,
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      showShadow: true,
      backgroundColor: Colors.amberAccent,

      mainScreen: _getScreen(),
      menuScreen: MenuScreen(
        currentItem: currentItem,
        onSelectedItem: (item) {
          setState(() => currentItem = item);

          // ZoomDrawer.of(context)!.close();
        },
      ),
    );
  }

  Widget _getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return MainScreen();
      case MenuItems.bills:
        return BillScreen();
      default:
        return MainScreen();
    }
  }
}
