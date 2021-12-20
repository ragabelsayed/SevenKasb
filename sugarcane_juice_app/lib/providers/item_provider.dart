import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sugarcane_juice/helper/box.dart';
import '/models/http_exception.dart';
import '/models/item.dart';
import '/providers/auth.dart';

// AVD
const itemUri = 'http://10.0.2.2:5000/api/item';
// wifi ip
// const itemUri = 'http://192.168.1.7:5000/api/item';

Uri url = Uri.parse(itemUri);
final itemProvider = ChangeNotifierProvider<ItemNotifier>((ref) {
  var _token = ref.watch(authProvider);
  return ItemNotifier(authToken: _token['token']);
});

class ItemNotifier extends ChangeNotifier {
  ItemNotifier({required this.authToken});
  late String authToken;
  final _itemBox = Boxes.getItemBox();
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

  Future<void> fetchAndSetData() async {
    _items = _itemBox.values.toList();
    notifyListeners();
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'charset': 'utf-8',
      'Authorization': 'Bearer $authToken',
    });
    if (response.statusCode >= 200 && response.statusCode < 400) {
      final extractedData = json.decode(response.body) as List;
      final List<Item> _loadedProducts = [];
      for (var item in extractedData) {
        _loadedProducts.add(
          Item.fromJson(
            json: item,
          ),
        );
      }
      _items = _loadedProducts;
      notifyListeners();
      await _itemBox.clear();
      await _itemBox.addAll(_items);
    } else {
      // _items = _itemBox.values.toList();
      return;
    }
  }

  void addItemOffline(Item item) {
    _items.add(item);
    notifyListeners();
    _itemBox.add(item);
  }

  Future<Item> addItem(Item item) async {
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
        quentity: item.quentity,
        unit: item.unit,
        type: item.type,
      );
      _items.add(newItem);
      notifyListeners();
      _itemBox.add(newItem);
      return newItem;
    } on FormatException {
      throw HttpException(
        'عفوًا لقد انتهت صلاحيتُك لإستخدام البرنامج \n أعِدْ تسجيل الدخول',
      );
    } catch (error) {
      throw HttpException(
        'تعذَّر الإتصال بالسيرفر برجاء التأكُّد من الإتصال بالشبكة',
      );
    }
  }

  Future<void> updateItem({required Item newItem}) async {
    Uri addurl = Uri.parse('http://10.0.2.2:5000/api/item/${newItem.id}');
    final itemIndex = _items.indexWhere((oldItem) => oldItem.id == newItem.id);
    if (itemIndex >= 0) {
      try {
        _items[itemIndex] = newItem;
        // notifyListeners();

        await http.put(
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
      } catch (error) {
        rethrow;
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

    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
    }
  }
}
