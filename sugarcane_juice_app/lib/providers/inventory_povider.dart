import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sugarcane_juice/helper/box.dart';
import 'package:sugarcane_juice/models/item.dart';
import 'auth.dart';
import '/models/inventory.dart';

final invBox = Boxes.getUserInventory();

abstract class MainInvenotry {
  Future<void> getInventory({
    required String date,
    String? year,
    String? month,
    String? day,
    required InventoryType inventoryType,
  });
}

final fetchInvProvider = Provider<FetchInventory>((ref) {
  var _token = ref.watch(authProvider);
  return FetchInventory(_token['token']);
});

final invDailyPurchasesProvider =
    StateNotifierProvider<InvDailyPurchaseNotifier, List<Inv>>((ref) {
  return InvDailyPurchaseNotifier();
});
final invDailySalesProvider =
    StateNotifierProvider<InvDailySalesNotifier, List<Inv>>((ref) {
  return InvDailySalesNotifier();
});
final invMonthlyPurchasesProvider =
    StateNotifierProvider<InvMonthlyPurchaseNotifier, List<Inv>>((ref) {
  return InvMonthlyPurchaseNotifier();
});
final invMonthlySalesProvider =
    StateNotifierProvider<InvMonthlySalesNotifier, List<Inv>>((ref) {
  return InvMonthlySalesNotifier();
});

class FetchInventory {
  final String authToken;
  FetchInventory(this.authToken);

  Future<void> fetchInventoryData({required String date}) async {
    late Uri url;
    url = Uri.parse('http://10.0.2.2:5000/api/mobilebarren/$date');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      },
    );
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    invBox.add(Inventory.fromJson(json: extractedData));
  }

  Future<void> lastSixtyDays() async {
    DateTime todey = DateTime.now();
    if (invBox.isNotEmpty) {
      DateTime lastInvDate = invBox.values.last.inventoryDate;
      for (var i = lastInvDate;
          i.year <= todey.year && i.month <= todey.month && i.day < todey.day;
          i = i.add(const Duration(days: 1))) {
        try {
          await fetchInventoryData(
            date: DateFormat.yMd().format(i).replaceAll(RegExp(r'/'), '-'),
          );
        } catch (e) {
          print(e.toString());
        }
        if (invBox.length > 60) {
          invBox.values.first.delete();
        }
      }
    } else {
      try {
        await fetchInventoryData(
          date: DateFormat.yMd().format(todey).replaceAll(RegExp(r'/'), '-'),
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

class InvDailyPurchaseNotifier extends StateNotifier<List<Inv>> {
  InvDailyPurchaseNotifier() : super([]);
  final invBoxList = invBox.values.toList();
  List<Inv> invList = [];

  void getDailyInventory({required DateTime date, required int type}) {
    bool isDateInBox = invBoxList.any((inv) =>
        inv.inventoryDate.year == date.year &&
        inv.inventoryDate.month == date.month &&
        inv.inventoryDate.day == date.day);

    if (isDateInBox) {
      invList.clear();
      state.clear();
      Inventory item = invBoxList.firstWhere(
        (inv) =>
            inv.inventoryDate.year == date.year &&
            inv.inventoryDate.month == date.month &&
            inv.inventoryDate.day == date.day,
      );
      if (item.itemList.isNotEmpty) {
        for (var inv in item.itemList) {
          List<dynamic> items = inv['priceItems'];
          var itemHistory = List.from(items.where((i) => i['type'] == type));
          if (itemHistory.isNotEmpty) {
            invList.add(Inv(
              inv['item'],
              itemHistory,
            ));
          }
        }
        state = [...invList];
      }
    }
  }
}

class InvDailySalesNotifier extends StateNotifier<List<Inv>> {
  InvDailySalesNotifier() : super([]);
  final invBoxList = invBox.values.toList();
  List<Inv> invList = [];

  void getDailyInventory({required DateTime date, required int type}) {
    bool isDateInBox = invBoxList.any((inv) =>
        inv.inventoryDate.year == date.year &&
        inv.inventoryDate.month == date.month &&
        inv.inventoryDate.day == date.day);

    if (isDateInBox) {
      invList.clear();
      state.clear();
      Inventory item = invBoxList.firstWhere(
        (inv) =>
            inv.inventoryDate.year == date.year &&
            inv.inventoryDate.month == date.month &&
            inv.inventoryDate.day == date.day,
      );
      if (item.itemList.isNotEmpty) {
        for (var inv in item.itemList) {
          List<dynamic> items = inv['priceItems'];
          var itemHistory = List.from(items.where((i) => i['type'] == type));
          if (itemHistory.isNotEmpty) {
            invList.add(Inv(
              inv['item'],
              itemHistory,
            ));
          }
        }
        state = [...invList];
      }
    }
  }
}

class InvMonthlyPurchaseNotifier extends StateNotifier<List<Inv>> {
  InvMonthlyPurchaseNotifier() : super([]);
  final invBoxList = invBox.values.toList();
  List<Inv> invList = [];

  void getMonthlyInventory({required DateTime date, required int type}) {
    bool isDateInBox = invBoxList.any((inv) =>
        inv.inventoryDate.year == date.year &&
        inv.inventoryDate.month == date.month);

    if (isDateInBox) {
      invList.clear();
      state.clear();
      List<Inventory> localInvs = invBoxList
          .where((inv) =>
              inv.inventoryDate.year == date.year &&
              inv.inventoryDate.month == date.month)
          .toList();

      for (var localInv in localInvs) {
        if (localInv.itemList.isNotEmpty) {
          for (var inv in localInv.itemList) {
            Item i = inv['item'];
            List<dynamic> items = inv['priceItems'];
            int invIndex = invList.indexWhere(
              (e) => e.item.id == i.id && e.item.unit.id == i.unit.id,
            );
            // check is there old item if there then update it if not add new one.
            if (invIndex != -1) {
              Inv oldInv = invList.elementAt(invIndex);
              var itemHistory =
                  List.from(items.where((i) => i['type'] == type));
              if (itemHistory.isNotEmpty) {
                oldInv.itemHistory.addAll(itemHistory.toList());
                invList[invIndex] = oldInv;
              }
            } else {
              var itemHistory =
                  List.from(items.where((i) => i['type'] == type));
              if (itemHistory.isNotEmpty) {
                invList.add(Inv(
                  inv['item'],
                  itemHistory,
                ));
              }
            }
          }
        }
      }
      state = [...invList];
    }
  }
}

class InvMonthlySalesNotifier extends StateNotifier<List<Inv>> {
  InvMonthlySalesNotifier() : super([]);
  final invBoxList = invBox.values.toList();
  List<Inv> invList = [];

  void getMonthlyInventory({required DateTime date, required int type}) {
    bool isDateInBox = invBoxList.any((inv) =>
        inv.inventoryDate.year == date.year &&
        inv.inventoryDate.month == date.month);

    if (isDateInBox) {
      invList.clear();
      state.clear();
      List<Inventory> localInvs = invBoxList
          .where((inv) =>
              inv.inventoryDate.year == date.year &&
              inv.inventoryDate.month == date.month)
          .toList();

      for (var localInv in localInvs) {
        if (localInv.itemList.isNotEmpty) {
          for (var inv in localInv.itemList) {
            Item i = inv['item'];
            List<dynamic> items = inv['priceItems'];
            int invIndex = invList.indexWhere(
              (e) => e.item.id == i.id && e.item.unit.id == i.unit.id,
            );
            // check is there old item if there then update it if not add new one.
            if (invIndex != -1) {
              Inv oldInv = invList.elementAt(invIndex);
              var itemHistory =
                  List.from(items.where((i) => i['type'] == type));
              if (itemHistory.isNotEmpty) {
                oldInv.itemHistory.addAll(itemHistory.toList());
                invList[invIndex] = oldInv;
              }
            } else {
              var itemHistory =
                  List.from(items.where((i) => i['type'] == type));
              if (itemHistory.isNotEmpty) {
                invList.add(Inv(
                  inv['item'],
                  itemHistory,
                ));
              }
            }
          }
        }
      }
      state = [...invList];
    }
  }
}

// final inventoryPurchasesProvider =
//     StateNotifierProvider<InventoryPurchaseNotifier, List<Inventory>>(
//   (ref) {
//     var _token = ref.watch(authProvider);
//     return InventoryPurchaseNotifier(_token['token']);
//   },
// );
// final inventorySalesProvider =
//     StateNotifierProvider<InventorySalesNotifier, List<Inventory>>(
//   (ref) {
//     var _token = ref.watch(authProvider);
//     return InventorySalesNotifier(_token['token']);
//   },
// );

// class InventoryPurchaseNotifier extends StateNotifier<List<Inventory>>
//     implements MainInvenotry {
//   InventoryPurchaseNotifier(this.authToken) : super([]);
//   final String authToken;

//   @override
//   Future<void> getInventory({
//     String? year,
//     String? month,
//     String? day,
//     required InventoryType inventoryType,
//   }) async {
//     late Uri url;
//     if (InventoryType.monthly == inventoryType) {
//       url = Uri.parse(
//           'http://10.0.2.2:5000/api/mobilebarren/0/year/$year/month/$month');
//     }
//     if (InventoryType.daily == inventoryType) {
//       url = Uri.parse('http://10.0.2.2:5000/api/mobilebarren/0/$day');
//     }

//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'charset': 'utf-8',
//         'Authorization': 'Bearer $authToken',
//       },
//     );
//     final extractedData = json.decode(response.body) as List;
//     final List<Inventory> _loadedProducts = [];
//     for (var inventory in extractedData) {
//       _loadedProducts.add(
//         Inventory.fromJson(json: inventory, inventoryType: inventoryType),
//       );
//     }
//     state = [...state, ..._loadedProducts];
//   }
// }

// class InventorySalesNotifier extends StateNotifier<List<Inventory>>
//     implements MainInvenotry {
//   InventorySalesNotifier(this.authToken) : super([]);
//   final String authToken;

//   @override
//   Future<void> getInventory({
//     String? year,
//     String? month,
//     String? day,
//     required InventoryType inventoryType,
//   }) async {
//     late Uri url;
//     if (InventoryType.monthly == inventoryType) {
//       url = Uri.parse(
//           'http://10.0.2.2:5000/api/mobilebarren/1/year/$year/month/$month');
//     }
//     if (InventoryType.daily == inventoryType) {
//       url = Uri.parse('http://10.0.2.2:5000/api/mobilebarren/1/$day');
//     }

//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'charset': 'utf-8',
//         'Authorization': 'Bearer $authToken',
//       },
//     );
//     final extractedData = json.decode(response.body) as List;
//     final List<Inventory> _loadedProducts = [];
//     for (var inventory in extractedData) {
//       _loadedProducts.add(
//         Inventory.fromJson(json: inventory, inventoryType: inventoryType),
//       );
//     }
//     state = [...state, ..._loadedProducts];
//   }
// }