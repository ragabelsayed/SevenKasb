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

final container = ProviderContainer();
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
  final _isAuth = await container.read(authProvider).tryAutoLogin();
  runApp(ProviderScope(child: MyApp(_isAuth)));
}

class MyApp extends StatefulWidget {
  final bool isAuth;
  const MyApp(this.isAuth);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
    container.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final auth = watch(authProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          // theme: ThemeData(primaryColor: Colors.green),
          home: widget.isAuth
              // auth.isAuth
              ? MainScreen()
              : LoginScreen(),
          // : FutureBuilder(
          //     future: auth.tryAutoLogin(),
          //     builder: (ctx, authResultsnapshot) {
          //       if (!authResultsnapshot.hasData) {
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   LoginScreen.routName,
          //   (route) => false,
          // );
          // Navigator.removeRoute(context, MaterialRo);
          // return LoginScreen();
          // }
          // if (authResultsnapshot.hasData) {
          //    MainScreen();
          // }
          // return authResultsnapshot.connectionState ==
          //           ConnectionState.waiting
          //       ?
          //       SplashScreen()
          //       : LoginScreen();
          // return SplashScreen();
          // },

          //  :                  await Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   LoginScreen.routName,
          //   (route) => false,
          // }),
          // initialRoute: LoginScreen.routName,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
