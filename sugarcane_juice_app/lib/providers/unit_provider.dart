import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sugarcane_juice_app/models/http_exception.dart';
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
  String? _currentUnit;

  String? get currentUnit {
    return _currentUnit;
  }

  void setCurrentUnit(String currentUnit) {
    _currentUnit = currentUnit;
    notifyListeners();
  }

  List<Unit> get items => [..._items];

  Uri url = Uri.parse(unitUri);
  Future<void> fetchAndSetData() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        // 'Authorization': 'Bearer $authToken',
      });
      final extractedData = json.decode(response.body) as List;
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

  Future<void> addUnit(Unit unit) async {
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'name': unit.name}),
      );
      final newUnit = Unit(
        id: json.decode(response.body)['unit']['id'],
        name: unit.name,
      );
      _items.add(newUnit);

      // print(response.statusCode);
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteUnit({required Unit unit}) async {
    Uri url = Uri.parse('http://10.0.2.2:5000/api/unit/${unit.id}');

    // final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // var existingProduct = _items[existingProductIndex];
    // _items.removeAt(existingProductIndex);

    _items.remove(unit);
    notifyListeners();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      },
    );
    print(response.statusCode);

    // if (response.statusCode >= 400) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    //   throw HttpException('Could not delete product.');
    // }
    // existingProduct = null;
  }
}
