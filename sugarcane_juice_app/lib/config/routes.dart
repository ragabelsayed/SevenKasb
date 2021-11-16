import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/screens/bill/bill_screen.dart';
import '/screens/bill/new_bill_screen.dart';
import '/screens/extra_expenses/extra_expenses_screen.dart';
import '/screens/home_screen.dart';
import '/screens/login/login_screen.dart';
import '/screens/main/main_screen.dart';
import '/screens/menu/menu_screen.dart';
import '/screens/offline/offline_screen.dart';
import '/screens/user/user_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    LoginScreen.routName: (ctx) => LoginScreen(),
    HomeScreen.routName: (ctx) => HomeScreen(),
    MainScreen.routName: (ctx) => MainScreen(),
    BillScreen.routName: (ctx) => BillScreen(),
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
