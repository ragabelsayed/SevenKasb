import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/unit.dart';
import '/providers/unit_provider.dart';

class DropdownIconBtn extends StatelessWidget {
  const DropdownIconBtn({Key? key, required this.newunit}) : super(key: key);
  final Function(Unit unit) newunit;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        List<Unit> unitList = watch(unitProvider).items;
        return PopupMenuButton<Unit>(
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.amber,
          ),
          onSelected: (value) {
            newunit(value);
          },
          itemBuilder: (BuildContext context) => unitList
              .map<PopupMenuItem<Unit>>(
                (unit) => PopupMenuItem(child: Text(unit.name), value: unit),
              )
              .toList(),
        );
      },
    );
  }
}
