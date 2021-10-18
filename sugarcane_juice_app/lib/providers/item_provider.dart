import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sugarcane_juice_app/models/http_exception.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/models/unit.dart';
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

  String? _currentItem;

  String? get currentItem {
    return _currentItem;
  }

  void setCurrentItem(String currentItem) {
    _currentItem = currentItem;
    notifyListeners();
  }

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
    } on FormatException {
      throw HttpException(
        'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاءاعد تسجيل الدخول',
      );
    } catch (error) {}
  }

  Future<void> addItem(Item item) async {
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'name': item.name,
          'price': item.price,
          'unitId': item.unit.id!,
          'type': item.type,
        }),
      );
      final newItem = Item(
        id: json.decode(response.body)['item']['id'],
        name: item.name,
        price: item.price,
        quentity: json.decode(response.body)['item']['quentity'].toString(),
        unit: item.unit,
        type: item.type,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateItem({required Item newItem}) async {
    Uri addurl = Uri.parse('http://10.0.2.2:5000/api/item/${newItem.id}');
    final itemIndex = _items.indexWhere((oldItem) => oldItem.id == newItem.id);
    if (itemIndex >= 0) {
      try {
        _items[itemIndex] = newItem;
        // notifyListeners();

        final response = await http.put(
          addurl,
          headers: {
            'Content-Type': 'application/json',
            'charset': 'utf-8',
            'Authorization': 'Bearer $authToken',
          },
          body: json.encode({
            'name': newItem.name,
            'price': newItem.price,
            'unitId': newItem.unit.id!,
            'type': newItem.type,
          }),
        );
        print(response.statusCode);
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteItem({required Item item}) async {
    Uri url = Uri.parse('http://10.0.2.2:5000/api/item/${item.id}');

    final existingItemIndex = _items.indexWhere((i) => i.id == item.id);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    // _items.remove(item);
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

    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      // throw HttpException('Could not delete product.');
    }
    // existingItem = null;
  }
  // Future<void> deleteProduct(String id) async {

  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProductIndex];
  //   _items.removeAt(existingProductIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingProduct = null;

  //   // _items.removeWhere((prod) => prod.id == id);
  // }
}
