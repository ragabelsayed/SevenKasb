import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice/providers/offline_provider.dart';
import 'package:sugarcane_juice/widget/toast_view.dart';
import '/models/extra_expenses.dart';
import '/models/http_exception.dart';
import '/providers/auth.dart';

// AVD
const extraUri = 'http://10.0.2.2:5000/api/extraexpenses';
// wifi ip
// const extraUri = 'http://192.168.1.7:5000/api/extraexpenses';
Uri url = Uri.parse(extraUri);

final extraExpensesProvider = FutureProvider<List<Extra>>((ref) async {
  var _token = ref.watch(authProvider);
  return ExtraExpensesProvider(authToken: _token['token']).fetchBills();
});

final addExtraExpensesProvider = Provider<ExtraExpensesProvider>((ref) {
  var _token = ref.watch(authProvider);
  return ExtraExpensesProvider(
      authToken: _token['token'], userId: _token['userId']);
});

class ExtraExpensesProvider {
  ExtraExpensesProvider({required this.authToken, this.userId});
  late String authToken;
  int? userId;

  Future<List<Extra>> fetchBills() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });

      final extractedData = json.decode(response.body) as List;
      final List<Extra> _loadedBill = [];
      for (var extra in extractedData) {
        _loadedBill.add(
          Extra.fromJson(
            json: extra as Map<String, dynamic>,
          ),
        );
      }
      return _loadedBill;
    } on FormatException {
      throw true;
      // HttpException(
      //   'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاء اعد تسجيل الدخول',
      // );
    } catch (error) {
      throw HttpException(
        'تعذر الاتصال بالسيرفر برجاء التاكد من الاتصال بالشبكة الصحيحة',
      );
    }
  }

  Future<void> addExtra(
      {required Extra extra, FToast? fToast, BuildContext? context}) async {
    // try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({
        'userId': userId,
        'reason': extra.reason,
        'paid': extra.cash,
        'createdAt': extra.dataTime.toIso8601String(),
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 400) {
      if (fToast != null) {
        return fToast.showToast(
          child: const ToastView(
            message: 'تم اضافة المصروف',
            success: true,
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } else {
        return;
      }
    }
    if (response.statusCode >= 400 && response.statusCode < 500) {
      if (fToast != null) {
        await context!.read(extraOfflineProvider.notifier).addExtra(extra);
        return fToast.showToast(
          child: const ToastView(
            message: 'حدث خطأ ولقد تم الحفظ اوف لاين',
            success: true,
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } else {
        throw HttpException('خطأ');
      }
    }
    if (response.statusCode > 500) {
      throw HttpException(
        'تعذر الاتصال بالسيرفر برجاء التاكد من الاتصال بالشبكة الصحيحة',
      );
    }
    // } on FormatException {
    //   throw true;
    //   // HttpException(
    //   //   'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاء اعد تسجيل الدخول',
    //   // );
    // } catch (error) {
    //   throw HttpException(
    //     'تعذر الاتصال بالسيرفر برجاء التاكد من الاتصال بالشبكة الصحيحة',
    //   );
  }
}
