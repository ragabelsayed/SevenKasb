import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '/models/extra_expenses.dart';
import 'extra_view.dart';

class ExtraDataTableView extends StatelessWidget {
  final List<Extra> extraList;
  const ExtraDataTableView({Key? key, required this.extraList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = [
      'عرض',
      'التاريخ',
      'المصروف',
      'الصارف',
    ];
    return Scrollbar(
      interactive: true,
      radius: const Radius.circular(30),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        child: DataTable(
          columns: _getColumns(columns),
          rows: _getRow(extras: extraList, context: context),
          headingTextStyle:
              Theme.of(context).textTheme.headline6!.copyWith(fontSize: 18),
          columnSpacing: MediaQuery.of(context).size.width / 10,
          horizontalMargin: 0.0,
          showBottomBorder: true,
        ),
      ),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map(
        (column) => DataColumn(
          numeric: true,
          label: SizedBox(
            width: 56,
            child: Text(
              column,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )
      .toList();

  List<DataRow> _getRow(
          {required List<Extra> extras, required BuildContext context}) =>
      extras.map(
        (extra) {
          final cells = [
            extra.user.knownAs,
            extra.cash,
            intl.DateFormat.Md().format(extra.dataTime),
          ];
          return DataRow(
            cells: [
              ..._getCells(cells),
              DataCell(
                TextButton(
                  child: Transform.rotate(
                    angle: 600,
                    origin: const Offset(0.0, 0.0),
                    child: const Icon(
                      Icons.forward_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ExtraView(extra: extra);
                      },
                    );
                  },
                ),
              ),
            ].reversed.toList(),
          );
        },
      ).toList();

  List<DataCell> _getCells(List<dynamic> cells) {
    var cellList = cells
        .map(
          (cell) => DataCell(
            SizedBox(
              width: 56,
              child: Text(
                '$cell',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // placeholder: true,
          ),
        )
        .toList();
    return cellList;
  }
}
