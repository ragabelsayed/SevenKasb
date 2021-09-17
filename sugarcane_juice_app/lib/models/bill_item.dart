class BillItems {
  final String id;
  final String billId;
  final double price;
  final double quentity;

  const BillItems({
    required this.id,
    required this.billId,
    required this.price,
    required this.quentity,
  });

  // factory BillItems.fromJson({required Map<String, dynamic> data}) {
  //   return BillItems(
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
