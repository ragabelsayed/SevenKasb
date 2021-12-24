import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'inventory_type.dart';
import '/models/inventory.dart' as type;

class SalesInventory extends StatelessWidget {
  final FToast fToast;
  const SalesInventory({Key? key, required this.fToast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InventoryType(
        fToast: fToast,
        type: type.InventoryType.sales,
      ),
    );
  }
}
