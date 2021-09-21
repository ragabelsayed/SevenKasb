import 'package:sugarcane_juice_app/models/unit.dart';

class Item {
  final int id;
  final String name;
  final double price;
  final double quentity;
  final Unit unit;
  final int type;

  const Item({
    required this.id,
    required this.name,
    required this.price,
    required this.quentity,
    required this.unit,
    required this.type,
  });

  factory Item.fromJson({required Map<String, dynamic> json}) {
    return Item(
      id: json['id'],
      name: json['name'],
      type: json['type'] ?? 0,
      price: json['price'] ?? 00,
      quentity: json['quentity'],
      unit: Unit(
        id: json['unitNavigation']['id'],
        name: json['unitNavigation']['name'],
      ),
    );
  }
}
