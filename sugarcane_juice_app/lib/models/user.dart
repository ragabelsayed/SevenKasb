import 'package:hive/hive.dart';

part '../helper/user.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveType(typeId: 0)
  int? id;

  @HiveType(typeId: 1)
  String? userName;

  @HiveType(typeId: 2)
  String? knownAs;

  @HiveType(typeId: 3)
  String? dateOfBirth;

  @HiveType(typeId: 4)
  String? city;

  @HiveType(typeId: 0)
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
