import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '/helper/box.dart';
import '/models/item.dart';
import 'auth.dart';
import '/models/inventory.dart';

final invBox = Boxes.getUserInventory();

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
    if (response.statusCode >= 200 && response.statusCode < 400) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      invBox.add(Inventory.fromJson(json: extractedData));
    } else {
      return;
    }
  }

  Future<void> lastSixtyDays() async {
    DateTime todey = DateTime.now();
    if (invBox.isNotEmpty) {
      DateTime lastInvDate = invBox.values.last.inventoryDate;
      invBox.values.last.delete();

      for (lastInvDate;
          lastInvDate.year <= todey.year &&
              lastInvDate.month <= todey.month &&
              lastInvDate.day < todey.day;
          lastInvDate = lastInvDate.add(const Duration(days: 1))) {
        await fetchInventoryData(
          date: DateFormat.yMd()
              .format(lastInvDate)
              .replaceAll(RegExp(r'/'), '-'),
        );

        if (invBox.length > 60) {
          invBox.values.first.delete();
        }
      }
    } else {
      await fetchInventoryData(
        date: DateFormat.yMd()
            // .format(todey)
            .format(DateTime(2021, 12, 8))
            .replaceAll(RegExp(r'/'), '-'),
      );
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
                for (var item in itemHistory) {
                  var indexPrice = oldInv.itemHistory
                      .indexWhere((e) => e['price'] == item['price']);

                  if (indexPrice != -1) {
                    oldInv.itemHistory.elementAt(indexPrice)['quentity'] +=
                        item['quentity'];
                    invList[invIndex] = oldInv;
                  } else {
                    oldInv.itemHistory.add(item);
                    invList[invIndex] = oldInv;
                  }
                }
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
                for (var item in itemHistory) {
                  var indexPrice = oldInv.itemHistory
                      .indexWhere((e) => e['price'] == item['price']);

                  if (indexPrice != -1) {
                    oldInv.itemHistory.elementAt(indexPrice)['quentity'] +=
                        item['quentity'];
                    invList[invIndex] = oldInv;
                  } else {
                    oldInv.itemHistory.add(item);
                    invList[invIndex] = oldInv;
                  }
                }
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
