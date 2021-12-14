import 'package:flutter/material.dart';
import '/models/inventory.dart';
import '/widget/dialog_title.dart';
import 'expansion_data_table.dart';

class ExpansionView extends StatefulWidget {
  // final Inventory inventory;
  final Inv inventory;
  const ExpansionView({Key? key, required this.inventory}) : super(key: key);
  @override
  _ExpansionViewState createState() => _ExpansionViewState();
}

class _ExpansionViewState extends State<ExpansionView> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DialogTitle(name: widget.inventory.item.name),
              const SizedBox(width: 5),
              DialogTitle(name: widget.inventory.item.unit.name),
            ],
          ),
          //   Text(
          //     widget.inventory.inventoryType == InventoryType.daily
          //         ? 'يومى'
          //         : 'شهري',
          //     textDirection: TextDirection.rtl,
          //     style: const TextStyle(
          //       fontStyle: FontStyle.italic,
          //     ),
          //   )
        ],
      ),
      textColor: Colors.amber,
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      expandedAlignment: Alignment.center,
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      iconColor: Colors.amber,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      controlAffinity: ListTileControlAffinity.leading,
      maintainState: true,
      children: [
        ExpansionDataTable(cashItemHistory: widget.inventory.itemHistory),
      ],
    );
  }
}
