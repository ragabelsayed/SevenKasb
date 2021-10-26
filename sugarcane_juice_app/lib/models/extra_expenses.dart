class Extra {
  int? id;
  String reason;
  String cash;
  DateTime dataTime;

  Extra({
    this.id,
    required this.reason,
    required this.cash,
    required this.dataTime,
  });

  factory Extra.fromJson({required Map<String, dynamic> json}) {
    return Extra(
      id: json['id'],
      reason: json['reason'],
      cash: json['paid'],
      dataTime: DateTime.parse('${json['createdAt']}'),
    );
  }
}
