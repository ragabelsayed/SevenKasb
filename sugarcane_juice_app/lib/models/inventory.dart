import 'package:hive_flutter/hive_flutter.dart';
import './item.dart';
import './unit.dart';
part '../helper/inventory.g.dart';

enum InventoryType { daily, monthly, purchase, sales }

@HiveType(typeId: 6)
class Inventory extends HiveObject {
  // @HiveField(0)
  // Item item;

  // @HiveField(1)
  // InventoryType inventoryType;

  // @HiveField(2)
  // List<Map<String, dynamic>> cashItemHistory;
  @HiveField(0)
  DateTime inventoryDate;
  @HiveField(1)
  List<Map<String, dynamic>> itemList;

  Inventory({
    // required this.item,
    // required this.cashItemHistory,
    // required this.inventoryType,
    required this.inventoryDate,
    required this.itemList,
  });

  factory Inventory.fromJson({
    required Map<String, dynamic> json,
    // required InventoryType inventoryType,
  }) {
    // List _cashItemHistory = json['priceItems'];
    List _itemList = json['barrenItems'];
    return Inventory(
      // item: Item(
      //   id: json['item']['id'],
      //   name: json['item']['name'],
      //   unit: Unit(
      //     id: json['item']['unitNavigation']['id'],
      //     name: json['item']['unitNavigation']['name'],
      //   ),
      // ),
      // cashItemHistory: _cashItemHistory
      //     .map((e) => {'price': e['price'], 'quentity': e['quentity']})
      //     .toList(),
      // inventoryType: inventoryType,
      inventoryDate: DateTime.parse(json['barrenDate']),
      itemList: _itemList
          .map((e) => {
                'item': Item(
                  id: e['item']['id'],
                  name: e['item']['name'],
                  unit: Unit(
                    id: e['item']['unitNavigation']['id'],
                    name: e['item']['unitNavigation']['name'],
                  ),
                ),
                'priceItems': e['priceItems']
                    .map((i) => {
                          'type': i['type'],
                          'price': i['price'],
                          'quentity': i['quentity'],
                        })
                    .toList(),
              })
          .toList(),
    );
  }
}
