import 'package:sugarcane_juice_app/models/unit.dart';

class Item {
  final int id;
  final String name;
  final double price;
  final double quentity;
  final Unit unit;
  final int type;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.quentity,
    required this.unit,
    required this.type,
  });
}
