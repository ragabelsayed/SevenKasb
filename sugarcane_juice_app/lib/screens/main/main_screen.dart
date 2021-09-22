import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/providers/item_provider.dart';
import 'package:sugarcane_juice_app/screens/main/widget/item_view.dart';
import '../../widget/menu_widget.dart';

class MainScreen extends ConsumerWidget {
  static const routName = '/main';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final items = watch(itemProvider);
    items.fetchAndSetData();
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle:
        //     SystemUiOverlayStyle(statusBarColor: Palette.primaryLightColor),
        backgroundColor: Palette.primaryColor,
        title: Text(
          'الاصناف',
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
      body: _buildDataTable(itemList: items.items, context: context),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new bill',
        child: Icon(Icons.add),
        // backgroundColor: Colors.green,
        backgroundColor: Colors.amber,
        onPressed: () {},
      ),
    );
  }

  Widget _buildDataTable(
      {required List<Item> itemList, required BuildContext context}) {
    final columns = [
      'عرض',
      'الكمية',
      'السعر',
      'الصنف',
    ];
    return SingleChildScrollView(
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DataTable(
        columns: _getColumns(columns),
        rows: _getRow(items: itemList, context: context),
        headingTextStyle: Theme.of(context).textTheme.headline6,
        columnSpacing: MediaQuery.of(context).size.width / 8,
        horizontalMargin: 0.0,
        showBottomBorder: true,
      ),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map(
        (column) => DataColumn(
          // numeric: true,
          label: SizedBox(
            width: 56,
            child: Text(
              column,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      )
      .toList();

  List<DataRow> _getRow(
          {required List<Item> items, required BuildContext context}) =>
      items.map(
        (item) {
          final cells = [
            item.name,
            item.price,
            item.quentity,
          ];
          return DataRow(
            cells: [
              ..._getCells(cells),
              DataCell(
                TextButton(
                  child: Transform.rotate(
                    angle: 600,
                    origin: Offset(0.0, 0.0),
                    child: Icon(
                      Icons.forward_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ItemView(item: item);
                      },
                    );
                  },
                ),
              ),
            ].reversed.toList(),
          );
        },
      ).toList();

  List<DataCell> _getCells(List<dynamic> cells) => cells
      .map(
        (cell) => DataCell(
          SizedBox(
            width: 56,
            child: Text(
              '$cell',
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // placeholder: true,
        ),
      )
      .toList();
}
