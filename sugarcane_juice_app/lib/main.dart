import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/config/routes.dart';
import 'package:sugarcane_juice_app/screens/home_screen.dart';
import 'package:sugarcane_juice_app/screens/splash_screen.dart';
import '/screens/login_screen.dart';
import 'providers/auth.dart';

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
    return Consumer(
      builder: (context, watch, _) {
        final auth = watch(authProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          // theme: ThemeData(primaryColor: Colors.green),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultsnapshot) =>
                      authResultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          // initialRoute: LoginScreen.routName,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
