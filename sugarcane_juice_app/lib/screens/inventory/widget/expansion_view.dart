import 'package:flutter/material.dart';
import '/models/inventory.dart';
import '/widget/dialog_title.dart';

class ExpansionView extends StatefulWidget {
  final Inventory inventory;
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
          DialogTitle(name: widget.inventory.item.name),
          Text(
            widget.inventory.inventoryType == InventoryType.daily
                ? 'شهري'
                : 'يومى',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          )
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
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ':وحدة القياس',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              widget.inventory.item.unit.name,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ],
    );
  }
}
