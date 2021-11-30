import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '/config/routes.dart';
import 'screens/login/login_screen.dart';
import 'screens/main/main_screen.dart';
import 'models/bill_item.dart';
import '/models/bill.dart';
import 'models/item.dart';
import 'models/unit.dart';
import 'models/user.dart';
import '/models/extra_expenses.dart';
import 'providers/auth.dart';

final container = ProviderContainer();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
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
  await Hive.openBox<Unit>('units');
  await Hive.openBox<Item>('items');

  final _isAuth = await container.read(authProvider.notifier).tryAutoLogin();
  runApp(ProviderScope(child: MyApp(isAuth: _isAuth)));
}

class MyApp extends StatefulWidget {
  final bool isAuth;
  const MyApp({Key? key, required this.isAuth}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (widget.isAuth) {
      context.read(authProvider.notifier).autoLogin();
    }
  }

  @override
  void dispose() {
    super.dispose();
    container.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SevenKasb',
      // theme: ThemeData(primaryColor: Colors.green),
      home: widget.isAuth ? const MainScreen() : const LoginScreen(),
      // initialRoute: LoginScreen.routName,
      routes: AppRoutes.routes,
    );
  }
}
