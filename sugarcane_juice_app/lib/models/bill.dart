class BillItems {
  final int id;
  final String itemName;
  // final double price;
  // final double quentity;

  const BillItems({
    required this.id,
    required this.itemName,
    // required this.price,
    // required this.quentity,
  });
}

class Bill {
  final int id;
  final int type;
  final Map<String, dynamic> user;
  final double price;
  final double paid;
  final String clientName;
  final DateTime dateTime;
  final List<BillItems> billItems;

  const Bill({
    required this.id,
    required this.type,
    required this.user,
    required this.price,
    required this.paid,
    required this.clientName,
    required this.dateTime,
    required this.billItems,
  });

  factory Bill.fromJson({required Map<String, dynamic> json}) {
    List _billItemList = json['billItems'];

    return Bill(
      id: json['id'],
      type: json['type'],
      user: json['user'],
      price: json['cost'],
      paid: json['paid'],
      clientName: json['clientName'],
      dateTime: DateTime.parse('${json['createdAt']}'),
      billItems: _billItemList
          .map(
            (e) => BillItems(
              id: e['itemId'],
              itemName: e['name'] ?? '',
              // price: e['price'],
              // quentity: e['quentity'],
            ),
          )
          .toList(),
      // List.from(
      //   _billItemList.map(
      //     (e) => BillItems(
      //       id: e['itemId'],
      //       itemName: e['name'] ?? '',
      //       // price: e['price'],
      //       // quentity: e['quentity'],
      //     ),
      //   ),
      // ),
    );
  }
}
