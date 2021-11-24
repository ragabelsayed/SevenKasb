import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sugarcane_juice/models/inventory.dart';
import 'package:sugarcane_juice/providers/inventory_povider.dart';
import 'package:sugarcane_juice/widget/dialog_title.dart';

class PurchaseInventory extends ConsumerWidget {
  final FToast fToast;
  const PurchaseInventory({Key? key, required this.fToast}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final inventory = watch(inventoryPurchasesProvider);
    return Scaffold();
  }
}
