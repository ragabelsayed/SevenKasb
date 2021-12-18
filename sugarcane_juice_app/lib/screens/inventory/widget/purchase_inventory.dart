import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/models/inventory.dart' as type;
import 'inventory_type.dart';

class PurchaseInventory extends StatelessWidget {
  final FToast fToast;
  const PurchaseInventory({Key? key, required this.fToast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InventoryType(
        fToast: fToast,
        type: type.InventoryType.purchase,
      ),
    );
  }
}
