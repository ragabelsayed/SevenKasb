class User {
  int? id;
  String? userName;
  String? knownAs;
  DateTime? dateOfBirth;
  String? city;
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
