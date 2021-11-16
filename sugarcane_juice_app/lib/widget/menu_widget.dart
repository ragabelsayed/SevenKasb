import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        FocusScope.of(context).unfocus();
        ZoomDrawer.of(context)!.toggle();
      },
    );
  }
}
