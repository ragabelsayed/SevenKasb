import 'item.dart';
import 'package:hive/hive.dart';
part '../helper/bill_item.g.dart';

@HiveType(typeId: 1)
class BillItems extends HiveObject {
  @HiveField(0)
  double price;

  @HiveField(1)
  double quentity;

  @HiveField(2)
  Item item;
  BillItems({
    required this.price,
    required this.quentity,
    required this.item,
  });
}
