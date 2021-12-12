import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'inventory_type.dart';

class PurchaseInventory extends StatelessWidget {
  final FToast fToast;
  const PurchaseInventory({Key? key, required this.fToast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InventoryType(
        fToast: fToast,
      ),
    );
  }
}
// class PurchaseInventory extends ConsumerWidget {
//   final FToast fToast;
//   const PurchaseInventory({Key? key, required this.fToast}) : super(key: key);

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     // final inventory = watch(inventoryPurchasesProvider);
//     return Scaffold(
//       // body: ListView.builder(
//       //   itemCount: inventory.length,
//       //   itemBuilder: (context, i) => ExpansionView(inventory: inventory[i]),
//       // ),
//       floatingActionButton: LinearFlowWidget(
//         fToast: fToast,
//         inventoryType: InventoryType.purchase,
//       ),
//     );
//   }
// }
