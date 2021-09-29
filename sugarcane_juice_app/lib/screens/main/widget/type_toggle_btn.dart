import 'package:flutter/material.dart';
import '/config/palette.dart';

class TypeToggleBtn extends StatefulWidget {
  final Function(int type) itemType;

  const TypeToggleBtn({required this.itemType});
  @override
  State<TypeToggleBtn> createState() => _TypeToggleBtnState();
}

class _TypeToggleBtnState extends State<TypeToggleBtn> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = [false, false, true];
    widget.itemType(0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToggleButtons(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderWidth: 0.5,
          disabledColor: Colors.black12,
          fillColor: Palette.primaryLightColor,
          selectedColor: Palette.primaryColor,
          children: [
            Text('الاثنين'),
            Text('بيع'),
            Text('شراء'),
          ],
          onPressed: (newIndex) {
            for (var index = 0; index < isSelected.length; index++) {
              setState(() {
                if (index == 0 && newIndex == 0) {
                  isSelected[index] = !isSelected[index];
                  // print('(2) الاثنين');
                  widget.itemType(2);
                } else if (index == 1 && newIndex == 1) {
                  isSelected[index] = !isSelected[index];
                  // print('(1) بيع');
                  widget.itemType(1);
                } else if (index == 2 && newIndex == 2) {
                  isSelected[index] = !isSelected[index];
                  // print('(0) شراء');
                  widget.itemType(0);
                } else {
                  isSelected[index] = false;
                }
              });
            }
          },
          isSelected: isSelected,
        ),
      ],
    );
  }
}
