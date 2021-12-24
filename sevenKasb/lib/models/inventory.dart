import 'package:hive_flutter/hive_flutter.dart';
import './item.dart';
import './unit.dart';
part '../helper/inventory.g.dart';

enum InventoryType { daily, monthly, purchase, sales }

@HiveType(typeId: 6)
class Inventory extends HiveObject {
  @HiveField(0)
  DateTime inventoryDate;
  @HiveField(1)
  List<Map<String, dynamic>> itemList;

  Inventory({
    required this.inventoryDate,
    required this.itemList,
  });

  factory Inventory.fromJson({required Map<String, dynamic> json}) {
    List _itemList = json['barrenItems'];
    return Inventory(
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

class Inv {
  final Item item;
  // final List<Map<String, dynamic>> itemHistory;
  final List<dynamic> itemHistory;

  Inv(this.item, this.itemHistory);
}
