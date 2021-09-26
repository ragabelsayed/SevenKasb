import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/unit.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';
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
      body: units.items.isEmpty
          ? Center(
              child: Text(
              '.⚖ اضف اول وحدة قياس',
              style: Theme.of(context).textTheme.subtitle1,
            ))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              itemCount: units.items.length,
              itemBuilder: (context, index) =>
                  _buildUnitView(context: context, unit: units.items[index]),
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

  Widget _buildUnitView({required BuildContext context, required Unit unit}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Palette.primaryLightColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              offset: const Offset(1.0, 2.0),
              blurRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          title: DialogTitle(name: unit.name),
          leading: IconButton(
            splashRadius: 1.0,
            tooltip: 'حذف هذه الوحدة',
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(
                    'هل انت متاكد من حذف هذة الوحدة؟',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Palette.primaryColor),
                          child: Text('الغاء'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          child: Text('حذف'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}
