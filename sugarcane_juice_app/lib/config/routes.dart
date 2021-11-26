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
import '/screens/inventory/inventory_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    LoginScreen.routName: (ctx) => const LoginScreen(),
    HomeScreen.routName: (ctx) => const HomeScreen(),
    MainScreen.routName: (ctx) => const MainScreen(),
    BillScreen.routName: (ctx) => const BillScreen(),
    NewBillScreen.routName: (ctx) => const NewBillScreen(),
    ExtraExpensesScreen.routName: (ctx) => const ExtraExpensesScreen(),
    UserScreen.routName: (ctx) => const UserScreen(),
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
        return const BillScreen();
      case MenuItems.extra:
        return const ExtraExpensesScreen();
      case MenuItems.inventory:
        return const InventoryScreen();
      case MenuItems.offline:
        return const OfflineScreen();
      case MenuItems.edit:
        return const UserScreen();
      default:
        return const BillScreen();
    }
  }
}
