import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/providers/auth.dart';

const itemUri = 'http://10.0.2.2:5000/api/item';

final itemProvider = ChangeNotifierProvider<ItemNotifier>((ref) {
  String _token = ref.watch(authProvider).token;
  return ItemNotifier(authToken: _token);
});

class ItemNotifier extends ChangeNotifier {
  ItemNotifier({required this.authToken});
  late String authToken;
  List<Item> _items = [];
  List<Item> get items => [..._items];

  Uri url = Uri.parse(itemUri);
  Future<void> fetchAndSetData() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });
      final extractedData = json.decode(response.body) as List;
      // print(extractedData);
      final List<Item> _loadedProducts = [];
      extractedData.forEach(
        (item) {
          _loadedProducts.add(
            Item.fromJson(
              json: item,
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
