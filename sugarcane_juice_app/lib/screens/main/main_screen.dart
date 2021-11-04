import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/config/routes.dart';
import '/screens/home_screen.dart';
import '/screens/menu/menu_screen.dart';
import '/widget/dialog_title.dart';
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
    List<Map<String, dynamic>> cardList = [
      {
        'name': 'الفواتير',
        'image': 'assets/images/invoice-bill.svg',
        'route': MenuItems.bills
      },
      {'name': 'الجرد', 'image': 'assets/images/stock.svg'},
      {
        'name': 'مصاريف إضافية',
        'image': 'assets/images/money.svg',
        'route': MenuItems.extra
      },
      {
        'name': 'الإعدادات',
        'image': 'assets/images/user-settings.svg',
        'route': MenuItems.edit,
      },
      {'name': 'اوف لاين', 'image': 'assets/images/wifi-off.svg'},
    ];
    return GridView.builder(
      itemCount: cardList.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, i) {
        return CardView(card: cardList[i]);
      },
    );
  }
}

class CardView extends StatelessWidget {
  final Map<String, dynamic> card;
  const CardView({required this.card});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routName);
        context.read(menuItemProvider.notifier).setItem(card['route']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Palette.primaryLightColor,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.amber.shade200,
          //     offset: Offset(0, 4),
          //     blurRadius: 10,
          //   ),
          // ],
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              offset: Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              card['image']!,
              height: 50,
              width: 50,
              color: card['name']! == 'الإعدادات'
                  ? Colors.green
                  : card['name']! == 'اوف لاين'
                      ? Colors.green
                      : null,
            ),
            const SizedBox(height: 20),
            DialogTitle(name: card['name']),
          ],
        ),
      ),
    );
  }
}
