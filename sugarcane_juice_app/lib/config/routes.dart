import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/screens/login_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    LoginScreen.routName: (ctx) => LoginScreen(),
  };
}
