import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/providers/auth.dart';

const billUri = 'http://10.0.2.2:5000/api/bill';
// final billProvider = StateNotifierProvider<BillNotifier, Bill>((ref) {
//   ref.
//   return
// });

// class BillNotifier extends StateNotifier<Bill> {
//   BillNotifier(): super();

// }

final billProvider = ChangeNotifierProvider<BillNotifier>((ref) {
  String _token = ref.watch(authProvider).token;
  return BillNotifier(authToken: _token);
});

class BillNotifier extends ChangeNotifier {
  BillNotifier({required this.authToken});
  late String authToken;
  List<Bill> _items = [];
  List<Bill> get items => [..._items];

  Uri url = Uri.parse(billUri);
  Future<void> fetchAndSetData() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });
      final extractedData = json.decode(response.body) as List;
      // print(extractedData.length);
      final List<Bill> _loadedProducts = [];
      extractedData.forEach(
        (bill) {
          _loadedProducts.add(
            Bill.fromJson(
              json: bill,
            ),
          );
        },
      );
      _items = _loadedProducts;
      // notifyListeners();
    } catch (error) {
      print(error);
      // throw error;
    }
  }

  Future<void> addBill(Bill bill) async {
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'userId': 1,
          'billItems': List.from(
            bill.billItems.map(
              (e) => {
                'quentity': 0.0,
                'price': 0.0,
                'itemId': e.item.id!,
              },
            ),
          ),
          'cost': sumTotal(bill),
          'paid': bill.paid,
          'clientName': bill.clientName,
          'createdAt': bill.dateTime.toIso8601String(),
          'type': bill.type,
        }),
      );
      final newBill = Bill(
        id: json.decode(response.body)['bill']['id'],
        billItems: bill.billItems,
        total: sumTotal(bill),
        paid: bill.paid,
        clientName: bill.clientName,
        dateTime: bill.dateTime,
        type: bill.type,
      );
      _items.add(newBill);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  static double getItemsTotal(
      {required String price, required String quentity}) {
    return double.parse(price) * double.parse(quentity);
  }

  static double sumTotal(Bill bill) {
    var sum = 0.0;
    if (bill.billItems.isNotEmpty) {
      bill.billItems.forEach((e) {
        sum += e.item.total!;
      });
      bill.total = sum;
      return bill.total;
    } else {
      return sum;
    }
  }

  static double getRemaining(Bill bill) {
    var sub = 0.0;
    if (bill.total >= bill.paid && bill.paid > 0) {
      sub = bill.total - bill.paid;
      return sub;
    } else {
      return sub;
    }
  }
}
