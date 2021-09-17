import 'package:sugarcane_juice_app/models/bill_item.dart';

class Bill {
  final String id;
  final String userId;
  final double price;
  final String clientName;
  final DateTime dateTime;
  final List<BillItems> billItems;

  const Bill({
    required this.id,
    required this.userId,
    required this.price,
    required this.clientName,
    required this.dateTime,
    required this.billItems,
  });

  // factory Bill.fromJson({required Map<String, dynamic> data}) {
  //   return Bill(
  //     id: prodId,
  //     title: data['title'],
  //     description: data['description'],
  //     images: data['imageUrl'].cast<String>(),
  //     colors: [
  //       Color(0xFFF6625E),
  //       Color(0xFF836DB8),
  //       Color(0xFFDECB9C),
  //       Colors.white,
  //     ],
  //     price: data['price'],
  //     rating: data['rating'],
  //     isFavourite: data['isFavourite'],
  //     isPopular: data['isPopular'],
  //   );
  // }
}