import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/models/unit.dart';

class BillItems {
  final int id;
  // final String itemName;
  final double price;
  final double quentity;
  final Item item;
  const BillItems({
    required this.id,
    // required this.itemName,
    required this.price,
    required this.quentity,
    required this.item,
  });
}

class Bill {
  final int id;
  // final Map<String, dynamic> user;
  final double price;
  final double paid;
  final String clientName;
  final DateTime dateTime;
  final List<BillItems> billItems;
  final int type;

  const Bill({
    required this.id,
    required this.type,
    // required this.user,
    required this.price,
    required this.paid,
    required this.clientName,
    required this.dateTime,
    required this.billItems,
  });

  factory Bill.fromJson({required Map<String, dynamic> json}) {
    List _billItemList = json['billItems'];
    return Bill(
      id: json['id'],
      type: json['type'] ?? 0,
      // user: json['user'],
      price: json['cost'] ?? 0.0,
      paid: json['paid'] ?? 0.0,
      clientName: json['clientName'] ?? '',
      dateTime: DateTime.parse('${json['createdAt']}'),
      billItems: _billItemList
          .map(
            (e) => BillItems(
              id: e['itemId'],
              // itemName: e['name'] ?? '',
              price: e['price'] ?? 0.0,
              quentity: e['quentity'] ?? 0.0,
              item: Item(
                id: e['itemNavigation']['id'],
                name: e['itemNavigation']['name'] ?? '',
                price: e['itemNavigation']['price'] ?? 0.0,
                quentity: e['itemNavigation']['quentity'] ?? 0.0,
                unit: Unit(
                  id: e['itemNavigation']['unitNavigation']['id'],
                  name: e['itemNavigation']['unitNavigation']['name'] ?? '',
                ),
                type: e['itemNavigation']['type'],
              ),
            ),
          )
          .toList(),
      // List.from(
      //   _billItemList.map(
      //     (e) => BillItems(
      //       id: e['itemId'],
      //       itemName: e['name'] ?? '',
      //       // price: e['price'],
      //       // quentity: e['quentity'],
      //     ),
      //   ),
      // ),
    );
  }
}
