import 'package:flutter/material.dart';
import '/screens/menu/menu_screen.dart';
import 'card_view.dart';

class CardList extends StatelessWidget {
  final AnimationController _controller;
  final bool _isList;
  const CardList(this._controller, this._isList);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _cardList = [
      {
        'name': 'الفواتير',
        'image': 'assets/images/invoice-bill.svg',
        'route': MenuItems.bills
      },
      {
        'name': 'مصاريف إضافية',
        'image': 'assets/images/money.svg',
        'route': MenuItems.extra
      },
      {'name': 'الجرد', 'image': 'assets/images/stock.svg'},
      {
        'name': 'الإعدادات',
        'image': 'assets/images/user-settings.svg',
        'route': MenuItems.edit,
      },
      {
        'name': 'أوف لاين',
        'image': 'assets/images/wifi-off.svg',
        'route': MenuItems.offline,
      },
    ];
    return GridView.builder(
      itemCount: _cardList.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isList ? 1 : 2,
        crossAxisSpacing: 20,
        childAspectRatio: _isList ? 2 : 1,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, i) {
        final int count = _cardList.length > 10 ? 10 : _cardList.length;
        final Animation<double> animation =
            Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn),
          ),
        );

        _controller.forward();
        return CardView(
          card: _cardList[i],
          animationController: _controller,
          animation: animation,
        );
      },
    );
  }
}
