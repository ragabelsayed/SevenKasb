import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '/models/bill.dart';
import '/models/http_exception.dart';
import '/providers/auth.dart';

// AVD
const billUri = 'http://10.0.2.2:5000/api/bill';
// wifi ip
// const billUri = 'http://192.168.1.7:5000/api/bill';
Uri url = Uri.parse(billUri);

abstract class BillRepository {
  Future<List<Bill>> fetchBills();
}

final billProvider = FutureProvider.autoDispose<List<Bill>>((ref) async {
  String _token = ref.watch(authProvider);
  return BillProvider(authToken: _token).fetchBills();
});

final addBillProvider = Provider.autoDispose<BillProvider>((ref) {
  String _token = ref.watch(authProvider);
  return BillProvider(authToken: _token);
});

final isOffLineProvider = StateProvider<bool>((ref) {
  return false;
});

class BillProvider implements BillRepository {
  BillProvider({required this.authToken});
  late String authToken;

  @override
  Future<List<Bill>> fetchBills() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });

      final extractedData = json.decode(response.body) as List;
      final List<Bill> _loadedBill = [];
      for (var bill in extractedData) {
        _loadedBill.add(
          Bill.fromJson(
            json: bill as Map<String, dynamic>,
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

  Future<void> addBill(Bill bill, [bool isOffline = false]) async {
    try {
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          // 'userId': 1,
          'userId': 3,
          'billItems': List.from(
            isOffline
                ? bill.offlineBillItems!.map(
                    (e) => {
                      'quentity': e.quentity,
                      'price': e.price,
                      'itemId': e.item.id!,
                    },
                  )
                : bill.billItems.map(
                    (e) => {
                      'quentity': e.quentity,
                      'price': e.price,
                      'itemId': e.item.id!,
                    },
                  ),
          ),
          'cost': isOffline ? sumTotal(bill, true) : sumTotal(bill),
          'paid': bill.paid,
          'clientName': bill.clientName,
          'createdAt': bill.dateTime.toIso8601String(),
          'type': bill.type,
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

  static double getItemsTotal(
          {required double price, required double quentity}) =>
      price * quentity;

  static double sumTotal(Bill bill, [bool isOffline = false]) {
    var sum = 0.0;
    if (isOffline) {
      if (bill.offlineBillItems!.isNotEmpty) {
        for (var e in bill.offlineBillItems!) {
          sum += getItemsTotal(price: e.price, quentity: e.quentity);
        }
        bill.total = sum;
        return bill.total;
      } else {
        return sum;
      }
    } else {
      if (bill.billItems.isNotEmpty) {
        for (var e in bill.billItems) {
          sum += e.item.total;
        }
        bill.total = sum;
        return bill.total;
      } else {
        return sum;
      }
    }
  }

  static double getRemaining(Bill bill) {
    var sub = 0.0;
    if (bill.total >= bill.paid && bill.paid > 0) {
      sub = bill.total - bill.paid;
      return sub;
    } else if (bill.total == 0) {
      return 0.0;
    } else {
      return sub;
    }
  }
}
