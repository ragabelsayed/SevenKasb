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
  String _token = ref.read(authProvider).token;
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
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      final List<Bill> _loadedProducts = [];
      // extractedData.forEach(
      //   (prodId, prodData) {
      //     _loadedProducts.add(
      //       Bill.fromJson(

      //       ),
      //     );
      //   },
      // );

      // _items = _loadedProducts;
      // notifyListeners();
    } catch (error) {
      print(error);
      // throw error;
    }
  }
}
