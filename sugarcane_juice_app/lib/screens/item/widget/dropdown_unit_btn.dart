import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/unit.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';
import 'package:sugarcane_juice_app/screens/unit/widget/input_unit.dart';

class DropdownUnitBtn extends StatefulWidget {
  final Function(int newUnit) unitId;
  final Unit? oldUnit;
  DropdownUnitBtn({required this.unitId, this.oldUnit});

  @override
  _DropdownUnitBtnState createState() => _DropdownUnitBtnState();
}

class _DropdownUnitBtnState extends State<DropdownUnitBtn> {
  String? _dropdownValue;
  late String _initdropdownValue;
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    if (widget.oldUnit != null) {
      _initdropdownValue = widget.oldUnit!.name;
      widget.unitId(widget.oldUnit!.id!);
      setState(() {
        isUpdated = !isUpdated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        _dropdownValue = watch(unitProvider).currentUnit;
        List<Unit> unitList = watch(unitProvider).items;
        List<String> unitMenu = [];
        unitList.forEach((unit) => unitMenu.add(unit.name));
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  builder: (context) => InputUnit(),
                ),
              ),
            ),
            DropdownButton<String>(
              value: isUpdated ? _initdropdownValue : _dropdownValue,
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
                  widget.unitId(id);
                  if (isUpdated) {
                    setState(() => isUpdated = !isUpdated);
                  }
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
          ],
        );
      },
    );
  }
}
