import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/config/routes.dart';
import '/screens/login_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // statusBarColor: Palette.primaryLightColor,
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.light,
    ),
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(primaryColor: Colors.green),
      // home: LoginScreen(),
      initialRoute: LoginScreen.routName,
      routes: AppRoutes.routes,
    );
  }
}
