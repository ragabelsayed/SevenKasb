import 'package:hive/hive.dart';
part '../helper/user.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? userName;

  @HiveField(2)
  String? knownAs;

  @HiveField(3)
  String? dateOfBirth;

  @HiveField(4)
  String? city;

  @HiveField(5)
  String? telephone;

  User({
    this.id,
    this.userName,
    this.knownAs,
    this.dateOfBirth,
    this.city,
    this.telephone,
  });

  factory User.fromJson({required Map<String, dynamic> json}) {
    return User(
      id: json['id'],
      userName: json['username'],
      knownAs: json['knownAs'],
      dateOfBirth: json['dateOfBirth'],
      city: json['city'],
      telephone: json['telephone'],
    );
  }
}
