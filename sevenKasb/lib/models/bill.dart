import '/models/unit.dart';
import '/models/item.dart';
import '/models/user.dart';
import 'bill_item.dart';
import 'package:hive/hive.dart';
part '../helper/bill.g.dart';

@HiveType(typeId: 0)
class Bill extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  User user;

  @HiveField(2)
  double total;

  @HiveField(3)
  double paid;

  @HiveField(4)
  String clientName;

  @HiveField(5)
  DateTime dateTime;

  @HiveField(6)
  List<BillItems> billItems;

  @HiveField(7)
  int type;

  @HiveField(8)
  HiveList<BillItems>? offlineBillItems;
  Bill({
    this.id,
    required this.type,
    required this.user,
    required this.total,
    required this.paid,
    required this.clientName,
    required this.dateTime,
    required this.billItems,
    this.offlineBillItems,
  });

  factory Bill.fromJson({required Map<String, dynamic> json}) {
    List _billItemList = json['billItems'];
    return Bill(
      id: json['id'],
      type: json['type'] ?? 0,
      user: User(
        id: json['userNavigation']['id'],
        knownAs: json['userNavigation']['knownAs'],
      ),
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
                unit: Unit(
                  id: e['itemNavigation']['unitNavigation']['id'],
                  name: e['itemNavigation']['unitNavigation']['name'] ?? '',
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
