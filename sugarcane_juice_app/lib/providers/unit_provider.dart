import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sugarcane_juice_app/models/unit.dart';
import 'package:sugarcane_juice_app/providers/auth.dart';

const unitUri = 'http://10.0.2.2:5000/api/unit';

final unitProvider = ChangeNotifierProvider<UnitNotifier>((ref) {
  String _token = ref.watch(authProvider).token;
  return UnitNotifier(authToken: _token);
});

class UnitNotifier extends ChangeNotifier {
  UnitNotifier({required this.authToken});
  late String authToken;
  List<Unit> _items = [];
  List<Unit> get items => [..._items];

  Uri url = Uri.parse(unitUri);
  Future<void> fetchAndSetData() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });
      final extractedData = json.decode(response.body) as List;
      // print(extractedData);
      final List<Unit> _loadedProducts = [];
      extractedData.forEach(
        (unit) {
          _loadedProducts.add(
            Unit.fromJson(
              json: unit,
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
}
