import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth.dart';
import '/models/inventory.dart';

abstract class MainInvenotry {
  Future<void> getInventory({
    // required String date,
    String? year,
    String? month,
    String? day,
    required InventoryType inventoryType,
  });
}

final inventoryPurchasesProvider =
    StateNotifierProvider<InventoryPurchaseNotifier, List<Inventory>>(
  (ref) {
    var _token = ref.watch(authProvider);
    return InventoryPurchaseNotifier(_token['token']);
  },
);
final inventorySalesProvider =
    StateNotifierProvider<InventorySalesNotifier, List<Inventory>>(
  (ref) {
    var _token = ref.watch(authProvider);
    return InventorySalesNotifier(_token['token']);
  },
);

class InventoryPurchaseNotifier extends StateNotifier<List<Inventory>>
    implements MainInvenotry {
  InventoryPurchaseNotifier(this.authToken) : super([]);
  final String authToken;

  @override
  Future<void> getInventory({
    String? year,
    String? month,
    String? day,
    required InventoryType inventoryType,
  }) async {
    late Uri url;
    if (InventoryType.monthly == inventoryType) {
      url = Uri.parse(
          'http://10.0.2.2:5000/api/mobilebarren/0/year/$year/month/$month');
    }
    if (InventoryType.daily == inventoryType) {
      url = Uri.parse('http://10.0.2.2:5000/api/mobilebarren/0/$day');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      },
    );
    final extractedData = json.decode(response.body) as List;
    final List<Inventory> _loadedProducts = [];
    for (var inventory in extractedData) {
      _loadedProducts.add(
        Inventory.fromJson(json: inventory, inventoryType: inventoryType),
      );
    }
    state = [...state, ..._loadedProducts];
  }
}

class InventorySalesNotifier extends StateNotifier<List<Inventory>>
    implements MainInvenotry {
  InventorySalesNotifier(this.authToken) : super([]);
  final String authToken;

  @override
  Future<void> getInventory({
    String? year,
    String? month,
    String? day,
    required InventoryType inventoryType,
  }) async {
    late Uri url;
    if (InventoryType.monthly == inventoryType) {
      url = Uri.parse(
          'http://10.0.2.2:5000/api/mobilebarren/1/year/$year/month/$month');
    }
    if (InventoryType.daily == inventoryType) {
      url = Uri.parse('http://10.0.2.2:5000/api/mobilebarren/1/$day');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      },
    );
    final extractedData = json.decode(response.body) as List;
    final List<Inventory> _loadedProducts = [];
    for (var inventory in extractedData) {
      _loadedProducts.add(
        Inventory.fromJson(json: inventory, inventoryType: inventoryType),
      );
    }
    state = [...state, ..._loadedProducts];
  }
}
