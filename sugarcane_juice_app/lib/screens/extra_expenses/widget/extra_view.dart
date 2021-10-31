import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '/config/palette.dart';
import '/models/extra_expenses.dart';
import '/widget/dialog_title.dart';

class ExtraView extends StatelessWidget {
  final Extra extra;
  const ExtraView({required this.extra});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              const DialogTitle(name: 'المصروف الإضافى'),
              const SizedBox(height: 10),
              // _buildRowView(
              //   context,
              //   name: ' :رقم المصروف',
              //   value: '${extra.id}',
              // ),
              // const SizedBox(height: 5),
              _buildRowView(
                context,
                name: ' :الصارف',
                value: '${extra.cash}',
              ),
              const SizedBox(height: 5),
              _buildRowView(
                context,
                name: ' :المصروف',
                value: '${extra.cash}  ج.م',
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    ' :التاريخ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${intl.DateFormat.yMd().format(extra.dataTime)}',
                  ),
                  Text(
                    '${intl.DateFormat.Hm().format(extra.dataTime)}',
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'السبب: ',
                style: Theme.of(context).textTheme.subtitle1,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Palette.primaryLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${extra.reason}',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRowView(BuildContext context,
      {required String name, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(value),
      ],
    );
  }
}
