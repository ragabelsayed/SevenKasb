import 'package:flutter/material.dart';

import '/config/constants.dart';
import '/config/palette.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColor,
        title: Text(
          // 'سڤن قصب',
          '7 قصب',
          textDirection: TextDirection.rtl,
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        shape: AppConstants.appBarBorder,
      ),
      body: CardList(),
    );
  }
}

class CardList extends StatefulWidget {
  const CardList({Key? key}) : super(key: key);
  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> cardList = [
      {'name': 'الفواتير', 'image': 'assets/images/invoice-bill.svg'},
      {'name': 'الجرد', 'image': 'assets/images/stock.svg'},
      {'name': 'مصاريف إضافية', 'image': 'assets/images/money.svg'},
      {'name': 'الإعدادات', 'image': 'assets/images/user-settings.svg'},
      {'name': 'اوف لاين', 'image': 'assets/images/wifi-off.svg'},
    ];
    return GridView.builder(
      itemCount: cardList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: 2,
      ),
      itemBuilder: (context, i) {
        return CardView(card: cardList[i]);
      },
    );
  }
}

class CardView extends StatelessWidget {
  final Map<String, String> card;
  const CardView({required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(),
    );
  }
}
