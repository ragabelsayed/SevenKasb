import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/unit.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';

class DropdownUnitBtn extends ConsumerWidget {
  Function(int newValue) unitId;
  DropdownUnitBtn({required this.unitId});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String? _dropdownValue = watch(unitProvider).currentUnit;
    //  = watch(unitProvider).items.first.name;
    List<Unit> unitList = watch(unitProvider).items;
    List<String> unitMenu = [];
    unitList.forEach((unit) => unitMenu.add(unit.name));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {},
          color: Colors.amber,
        ),
        SizedBox(
          // width: MediaQuery.of(context).size.width * 0.5,
          child: DropdownButton<String>(
            value: _dropdownValue,
            style: const TextStyle(
              color: Colors.black,
            ),
            underline: Container(
              height: 1,
              color: Colors.amberAccent,
            ),
            alignment: Alignment.center,
            hint: Text('وحدة القياس'),
            isDense: true,
            onChanged: (String? newValue) {
              context.read(unitProvider).setCurrentUnit(newValue!);
              if (newValue.isNotEmpty) {
                int id =
                    unitList.firstWhere((unit) => unit.name == newValue).id!;
                unitId(id);
              }
            },
            items: unitMenu
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
