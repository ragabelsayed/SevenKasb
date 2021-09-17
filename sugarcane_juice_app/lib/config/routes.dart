import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/screens/bill_screen.dart';
import 'package:sugarcane_juice_app/screens/home_screen.dart';
import 'package:sugarcane_juice_app/screens/login_screen.dart';
import 'package:sugarcane_juice_app/screens/main/main_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    LoginScreen.routName: (ctx) => LoginScreen(),
    HomeScreen.routName: (ctx) => HomeScreen(),
    MainScreen.routName: (ctx) => MainScreen(),
    BillScreen.routName: (ctx) => BillScreen(),
  };
}
