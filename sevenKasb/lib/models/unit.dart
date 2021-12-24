import 'package:hive/hive.dart';
part '../helper/unit.g.dart';

@HiveType(typeId: 4)
class Unit extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  Unit({this.id, this.name = ''});

  factory Unit.fromJson({required Map<String, dynamic> json}) {
    return Unit(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
