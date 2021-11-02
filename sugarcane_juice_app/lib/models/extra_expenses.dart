import 'package:sugarcane_juice_app/models/user.dart';

class Extra {
  int? id;
  User user;
  String reason;
  double cash;
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
