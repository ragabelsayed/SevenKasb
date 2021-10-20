import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/models/unit.dart';

class BillItems {
  double price;
  double quentity;
  Item item;
  BillItems({
    required this.price,
    required this.quentity,
    required this.item,
  });
}

class Bill {
  int? id;
  Map<String, dynamic> user;
  double total;
  double paid;
  String clientName;
  DateTime dateTime;
  List<BillItems> billItems;
  int type;

  Bill({
    this.id,
    required this.type,
    required this.user,
    required this.total,
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
      user: json['userNavigation'],
      total: json['cost'] ?? 0.0,
      paid: json['paid'] ?? 0.0,
      clientName: json['clientName'] ?? '',
      dateTime: DateTime.parse('${json['createdAt']}'),
      billItems: _billItemList
          .map(
            (e) => BillItems(
              price: e['price'] ?? 0.0,
              quentity: e['quentity'] ?? 0.0,
              item: Item(
                id: e['itemNavigation']['id'],
                name: e['itemNavigation']['name'] ?? '',
                price: '${e['itemNavigation']['price']}',
                quentity: '${e['itemNavigation']['quentity']}',
                unit: Unit(
                  id: e['itemNavigation']['unitNavigation']['id'],
                  name: e['itemNavigation']['unitNavigation']['name'] ?? '',
                ),
                type: e['itemNavigation']['type'] ?? 0,
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
