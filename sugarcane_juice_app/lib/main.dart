import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:sugarcane_juice_app/config/routes.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/models/extra_expenses.dart';

import 'package:sugarcane_juice_app/screens/splash_screen.dart';
import '/screens/login_screen.dart';
import 'models/bill_item.dart';
import 'models/item.dart';
import 'models/unit.dart';
import 'models/user.dart';
import 'providers/auth.dart';
import 'screens/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // statusBarColor: Palette.primaryLightColor,
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.light,
    ),
  );
  await Hive.initFlutter();
  Hive
    ..registerAdapter(BillAdapter())
    ..registerAdapter(BillItemsAdapter())
    ..registerAdapter(UserAdapter())
    ..registerAdapter(ItemAdapter())
    ..registerAdapter(UnitAdapter())
    ..registerAdapter(ExtraAdapter());

  await Hive.openBox<Bill>('bills');
  await Hive.openBox<BillItems>('billItems');
  await Hive.openBox<Extra>('extraExpenses');
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
              ? MainScreen()
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
