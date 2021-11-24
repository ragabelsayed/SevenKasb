import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth.dart';
import '/models/inventory.dart';

abstract class MainInvenotry {
  Future<void> getInventory({
    required String date,
    required InventoryType inventoryType,
  });
}

final inventoryPurchasesProvider = StateNotifierProvider.autoDispose<
    InventoryPurchaseNotifier, List<Inventory>>(
  (ref) {
    String _token = ref.watch(authProvider);
    return InventoryPurchaseNotifier(_token);
  },
);

class InventoryPurchaseNotifier extends StateNotifier<List<Inventory>>
    implements MainInvenotry {
  InventoryPurchaseNotifier(this.authToken) : super([]);
  final String authToken;
  @override
  Future<void> getInventory({
    required String date,
    required InventoryType inventoryType,
  }) async {
    Uri url = Uri.parse('http://10.0.2.2:5000/mobile/year/2021/month/11');

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
