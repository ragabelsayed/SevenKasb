import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sugarcane_juice/models/inventory.dart';
import 'package:sugarcane_juice/providers/inventory_povider.dart';
import 'expansion_view.dart';

class PurchaseInventory extends ConsumerWidget {
  final FToast fToast;
  const PurchaseInventory({Key? key, required this.fToast}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final inventory = watch(inventoryPurchasesProvider);
    return Scaffold(
      body: ListView.builder(
        itemCount: inventory.length,
        itemBuilder: (context, i) => ExpansionView(inventory: inventory[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          context
              .read(inventoryPurchasesProvider.notifier)
              .getInventory(date: 'date', inventoryType: InventoryType.daily);
        },
      ),
    );
  }
}
