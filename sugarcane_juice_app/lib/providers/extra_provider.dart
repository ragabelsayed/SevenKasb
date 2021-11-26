import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/extra_expenses.dart';
import '/models/http_exception.dart';
import '/providers/auth.dart';

// AVD
const extraUri = 'http://10.0.2.2:5000/api/extraexpenses';
// wifi ip
// const extraUri = 'http://192.168.1.7:5000/api/extraexpenses';
Uri url = Uri.parse(extraUri);

final extraExpensesProvider = FutureProvider<List<Extra>>((ref) async {
  String _token = ref.watch(authProvider);
  return ExtraExpensesProvider(authToken: _token).fetchBills();
});

final addExtraExpensesProvider = Provider<ExtraExpensesProvider>((ref) {
  String _token = ref.watch(authProvider);
  return ExtraExpensesProvider(authToken: _token);
});

class ExtraExpensesProvider {
  ExtraExpensesProvider({required this.authToken});
  late String authToken;

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
      throw HttpException(
        'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاء اعد تسجيل الدخول',
      );
    } catch (error) {
      throw HttpException(
        'تعذر الاتصال بالسيرفر برجاء التاكد من الاتصال بالشبكة الصحيحة',
      );
    }
  }

  Future<void> addExtra(Extra extra) async {
    try {
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'userId': 1,
          'reason': extra.reason,
          'paid': extra.cash,
          'createdAt': extra.dataTime.toIso8601String(),
        }),
      );
    } on FormatException {
      throw HttpException(
        'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاء اعد تسجيل الدخول',
      );
    } catch (error) {
      throw HttpException(
        'تعذر الاتصال بالسيرفر برجاء التاكد من الاتصال بالشبكة الصحيحة',
      );
    }
  }
}
