import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/item.dart';
import '/providers/item_provider.dart';
import '/models/unit.dart';
import '/providers/unit_provider.dart';

class DropdownIconBtn extends StatelessWidget {
  const DropdownIconBtn({
    Key? key,
    this.isItem = false,
    required this.dropdownValue,
  }) : super(key: key);
  final Function({Unit? dropdownUnitValue, Item? dropdownItemValue})
      dropdownValue;
  final bool isItem;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        List<Unit> unitList = watch(unitProvider).items;
        List<Item> itemList = watch(itemProvider).items;
        return isItem
            ? PopupMenuButton<Item>(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.amber,
                ),
                onSelected: (value) {
                  dropdownValue(dropdownItemValue: value);
                },
                itemBuilder: (BuildContext context) => itemList
                    .map<PopupMenuItem<Item>>(
                      (item) =>
                          PopupMenuItem(child: Text(item.name), value: item),
                    )
                    .toList(),
              )
            : PopupMenuButton<Unit>(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.amber,
                ),
                onSelected: (value) {
                  dropdownValue(dropdownUnitValue: value);
                },
                itemBuilder: (BuildContext context) => unitList
                    .map<PopupMenuItem<Unit>>(
                      (unit) =>
                          PopupMenuItem(child: Text(unit.name), value: unit),
                    )
                    .toList(),
              );
      },
    );
  }
}
