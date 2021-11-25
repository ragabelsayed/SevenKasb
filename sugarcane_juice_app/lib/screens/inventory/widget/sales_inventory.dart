import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/models/inventory.dart';
import '/providers/inventory_povider.dart';
import 'expansion_view.dart';
import 'linear_flow_btns.dart';

class SalesInventory extends ConsumerWidget {
  final FToast fToast;
  const SalesInventory({Key? key, required this.fToast}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final inventory = watch(inventorySalesProvider);
    return Scaffold(
      body: ListView.builder(
        itemCount: inventory.length,
        itemBuilder: (context, i) => ExpansionView(inventory: inventory[i]),
      ),
      floatingActionButton: LinearFlowWidget(
        fToast: fToast,
        inventoryType: InventoryType.sales,
      ),
    );
  }
}
