import 'package:sugarcane_juice_app/models/unit.dart';

class Item {
  int? id;
  String name;
  String price;
  String quentity;
  Unit unit;
  int type;
  double? total;

  Item({
    this.id,
    required this.name,
    this.price = '0.0',
    this.quentity = '0.0',
    required this.unit,
    this.type = 0,
    this.total,
  });

  factory Item.fromJson({required Map<String, dynamic> json}) {
    return Item(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      price: json['price'].toString(),
      quentity: json['quentity'].toString(),
      unit: Unit(
        id: json['unitNavigation']['id'],
        name: json['unitNavigation']['name'],
      ),
    );
  }
}
