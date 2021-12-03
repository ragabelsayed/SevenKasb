import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sugarcane_juice/helper/box.dart';
import '/models/http_exception.dart';
import '/models/unit.dart';
import '/providers/auth.dart';

// AVD
const unitUri = 'http://10.0.2.2:5000/api/unit';
// wifi ip
// const unitUri = 'http://192.168.1.7:5000/api/unit';

final unitProvider = ChangeNotifierProvider<UnitNotifier>((ref) {
  var _token = ref.watch(authProvider);
  return UnitNotifier(authToken: _token['token']);
});

class UnitNotifier extends ChangeNotifier {
  UnitNotifier({required this.authToken});
  late String authToken;
  final _unitBox = Boxes.getUnitBox();
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
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'charset': 'utf-8',
      'Authorization': 'Bearer $authToken',
    });
    if (response.statusCode >= 200 && response.statusCode < 400) {
      final extractedData = json.decode(response.body) as List;
      final List<Unit> _loadedProducts = [];
      for (var unit in extractedData) {
        _loadedProducts.add(
          Unit.fromJson(
            json: unit,
          ),
        );
      }
      _items = _loadedProducts;
      await _unitBox.clear();
      await _unitBox.addAll(_items);
    } else {
      _items = _unitBox.values.toList();
    }
  }

  Future<Unit> addUnit(Unit unit) async {
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
      return newUnit;
    } on FormatException {
      throw HttpException(
        'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاء اعد تسجيل الدخول',
      );
    } catch (error) {
      throw HttpException(
        'لم تتم إضافة هذة الوحدة',
      );
    }
  }

  Future<void> deleteUnit({required Unit unit}) async {
    Uri url = Uri.parse('http://10.0.2.2:5000/api/unit/${unit.id}');

    final existingUnitIndex = _items.indexWhere((u) => u.id == unit.id);
    Unit? existingUnit = _items[existingUnitIndex];
    _items.removeAt(existingUnitIndex);

    _items.remove(unit);
    notifyListeners();
    try {
      await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
      );
    } catch (e) {
      _items.insert(existingUnitIndex, existingUnit);
      notifyListeners();
      existingUnit = null;
      throw HttpException('خطأ لم يتم حذف الوحدة');
    }
  }
}
