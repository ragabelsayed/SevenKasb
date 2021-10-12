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
    required this.price,
    this.quentity = '0.0',
    required this.unit,
    required this.type,
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
