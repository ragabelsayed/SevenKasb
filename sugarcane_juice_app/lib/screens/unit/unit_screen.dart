import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';
import 'package:sugarcane_juice_app/widget/menu_widget.dart';

class UnitScreen extends ConsumerWidget {
  static const routName = '/unit';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final units = watch(unitProvider);
    units.fetchAndSetData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColor,
        title: Text(
          'وحدة القياس',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        leading: MenuWidget(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'اضافة وحدة قياس جديدة',
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (context) => ,
          // );
        },
      ),
    );
  }
}
