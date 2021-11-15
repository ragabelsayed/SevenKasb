import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/screens/bill/bill_screen.dart';
import 'package:sugarcane_juice_app/screens/bill/new_bill_screen.dart';
import 'package:sugarcane_juice_app/screens/extra_expenses/extra_expenses_screen.dart';
import 'package:sugarcane_juice_app/screens/home_screen.dart';
import 'package:sugarcane_juice_app/screens/login_screen.dart';
import 'package:sugarcane_juice_app/screens/main/main_screen.dart';
import 'package:sugarcane_juice_app/screens/menu/menu_screen.dart';
import 'package:sugarcane_juice_app/screens/offline/offline_screen.dart';
import 'package:sugarcane_juice_app/screens/unit/unit_screen.dart';
import 'package:sugarcane_juice_app/screens/user/user_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    LoginScreen.routName: (ctx) => LoginScreen(),
    HomeScreen.routName: (ctx) => HomeScreen(),
    MainScreen.routName: (ctx) => MainScreen(),
    // ItemScreen.routName: (ctx) => ItemScreen(),
    BillScreen.routName: (ctx) => BillScreen(),
    UnitScreen.routName: (ctx) => UnitScreen(),
    NewBillScreen.routName: (ctx) => NewBillScreen(),
    ExtraExpensesScreen.routName: (ctx) => ExtraExpensesScreen(),
    UserScreen.routName: (ctx) => UserScreen(),
  };
}

final menuItemProvider = StateNotifierProvider<ItemNotifier, MenuItem>((ref) {
  return ItemNotifier();
});

class ItemNotifier extends StateNotifier<MenuItem> {
  ItemNotifier() : super(MenuItems.bills);

  void setItem(MenuItem menuItem) => state = menuItem;

  Widget getScreen() {
    switch (state) {
      case MenuItems.bills:
        return BillScreen();
      case MenuItems.extra:
        return ExtraExpensesScreen();
      case MenuItems.offline:
        return OfflineScreen();
      case MenuItems.edit:
        return UserScreen();
      default:
        return BillScreen();
    }
  }
}
