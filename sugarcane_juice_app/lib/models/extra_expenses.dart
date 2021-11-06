import 'package:sugarcane_juice_app/models/user.dart';

import 'package:hive/hive.dart';

part '../helper/extra_expenses.g.dart';

@HiveType(typeId: 5)
class Extra {
  @HiveField(0)
  int? id;

  @HiveField(1)
  User user;

  @HiveField(2)
  String reason;

  @HiveField(3)
  double cash;

  @HiveField(4)
  DateTime dataTime;

  Extra({
    this.id,
    required this.user,
    required this.reason,
    required this.cash,
    required this.dataTime,
  });

  factory Extra.fromJson({required Map<String, dynamic> json}) {
    return Extra(
      id: json['id'],
      user: User(
        id: json['userNavigation']['id'],
        knownAs: json['userNavigation']['knownAs'],
      ),
      reason: json['reason'],
      cash: json['paid'],
      dataTime: DateTime.parse('${json['createdAt']}'),
    );
  }
}
