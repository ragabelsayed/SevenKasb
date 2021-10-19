import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/providers/unit_provider.dart';
import '../unit/widget/input_unit.dart';
import '../unit/widget/unit_view.dart';
import '/widget/banner_message.dart';
import '/widget/menu_widget.dart';

class UnitScreen extends StatelessWidget {
  static const routName = '/unit';

  @override
  Widget build(BuildContext context) {
    FToast ftoast = FToast().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColor,
        title: Text(
          'وحدة القياس',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        leading: MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
      body: FutureBuilder(
        future: context.read(unitProvider).fetchAndSetData().catchError(
              (e) => getBanner(context: context, errorMessage: e.toString()),
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer(
              builder: (context, watch, child) {
                final units = watch(unitProvider).items;
                if (units.isEmpty) {
                  return Center(
                    child: Text(
                      '.⚖ اضف اول وحدة قياس',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    itemCount: units.length,
                    itemBuilder: (context, index) => UnitView(
                      unit: units[index],
                      toast: ftoast,
                    ),
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'اضافة وحدة قياس جديدة',
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => InputUnit(toast: ftoast),
        ),
      ),
    );
  }
}
