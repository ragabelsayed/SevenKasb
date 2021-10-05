import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/providers/item_provider.dart';
import 'package:sugarcane_juice_app/screens/item/widget/item_view.dart';
import '../../widget/menu_widget.dart';
import 'widget/item_input_form.dart';

class ItemScreen extends StatefulWidget {
  static const routName = '/main';
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  void initState() {
    super.initState();
    context.read(itemProvider).fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    // final items = watch(itemProvider);
    // items.fetchAndSetData();
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
      body: Consumer(builder: (context, watch, child) {
        final items = watch(itemProvider);
        return _buildDataTable(itemList: items.items, context: context);
      }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'اضافة صنف',
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => IputItemForm(),
          );
        },
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
