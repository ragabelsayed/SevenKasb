class User {
  int? id;
  String userName;
  String knownAs;
  DateTime dateOfBirth;
  String city;
  String telephone;

  User({
    this.id,
    required this.userName,
    required this.knownAs,
    required this.dateOfBirth,
    required this.city,
    required this.telephone,
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
