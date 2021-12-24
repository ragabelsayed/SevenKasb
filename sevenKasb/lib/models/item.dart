import '/models/unit.dart';
import 'package:hive/hive.dart';
part '../helper/item.g.dart';

@HiveType(typeId: 2)
class Item extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String price;

  @HiveField(3)
  String quentity;

  @HiveField(4)
  Unit unit;

  @HiveField(5)
  int type;

  @HiveField(6)
  double total;

  Item({
    this.id,
    required this.name,
    this.price = '0.0',
    this.quentity = '0.0',
    required this.unit,
    this.type = 0,
    this.total = 0.0,
  });

  factory Item.fromJson({required Map<String, dynamic> json}) {
    return Item(
      id: json['id'],
      name: json['name'],
      // type: json['type'],
      price: json['price'].toString(),
      quentity: json['quentity'].toString(),
      unit: Unit(
        id: json['unitNavigation']['id'],
        name: json['unitNavigation']['name'],
      ),
    );
  }
}
