import './item.dart';
import './unit.dart';

class Inventory {
  Item item;
  List<Map<String, dynamic>> cashItemHistory;
  Inventory({required this.item, required this.cashItemHistory});

  factory Inventory.fromJson({required Map<String, dynamic> json}) {
    List _cashItemHistory = json['priceItems'];
    return Inventory(
      item: Item(
        id: json['item']['id'],
        name: json['item']['name'],
        unit: Unit(
          id: json['item']['unitNavigation']['id'],
          name: json['item']['unitNavigation']['name'],
        ),
      ),
      cashItemHistory: _cashItemHistory
          .map((e) => {'price': e['price'], 'quentity': e['quentity']})
          .toList(),
    );
  }
}
