import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/models/bill_item.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/providers/item_provider.dart';
import 'package:sugarcane_juice_app/screens/item/widget/item_input_form.dart';
import 'package:sugarcane_juice_app/screens/unit/widget/input_unit.dart';

class DropdownItemBtn extends StatefulWidget {
  final Function(Item item) billItem;
  final BillItems? oldBillItem;
  const DropdownItemBtn({required this.billItem, this.oldBillItem});

  @override
  _DropdownItemBtnState createState() => _DropdownItemBtnState();
}

class _DropdownItemBtnState extends State<DropdownItemBtn> {
  String? _dropdownValue;
  late String _initdropdownValue;
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    if (widget.oldBillItem != null) {
      _initdropdownValue = widget.oldBillItem!.item.name;
      widget.billItem(widget.oldBillItem!.item);
      setState(() {
        isUpdated = !isUpdated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        _dropdownValue = watch(itemProvider).currentItem;
        List<Item> itemList = watch(itemProvider).items;
        List<String> itemMenu = [];
        itemList.forEach((unit) => itemMenu.add(unit.name));
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 6),
                    blurRadius: 10,
                    color: Color(0xFFB0B0B0).withOpacity(0.2),
                  ),
                ],
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Palette.primaryLightColor,
                  primary: Colors.amber,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 27,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => IputItemForm(isNew: true),
                ),
              ),
            ),
            DropdownButton<String>(
              value: isUpdated ? _initdropdownValue : _dropdownValue,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.amberAccent,
              ),
              alignment: Alignment.center,
              hint: Text('الاصناف'),
              isDense: true,
              onChanged: (String? newValue) {
                context.read(itemProvider).setCurrentItem(newValue!);
                if (newValue.isNotEmpty) {
                  Item item =
                      itemList.firstWhere((item) => item.name == newValue);
                  widget.billItem(item);
                  if (isUpdated) {
                    setState(() => isUpdated = !isUpdated);
                  }
                }
              },
              items: itemMenu
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
