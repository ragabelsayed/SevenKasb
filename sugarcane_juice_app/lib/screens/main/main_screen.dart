import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/config/routes.dart';
import '/screens/home_screen.dart';
import '/screens/menu/menu_screen.dart';
import '/widget/dialog_title.dart';
import '/config/constants.dart';
import '/config/palette.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isList = false;
  late Widget _bodyList;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _bodyList = CardList(_animationController, _isList);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

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
        actions: [
          IconButton(
            icon:
                FaIcon(_isList ? FontAwesomeIcons.listUl : FontAwesomeIcons.th),
            onPressed: () {
              setState(() => _isList = !_isList);
              _animationController.reverse().then((value) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _bodyList = CardList(_animationController, _isList);
                });
              });
            },
          ),
        ],
        shape: AppConstants.appBarBorder,
      ),
      body: FutureBuilder(
          future: _getData(),
          builder: (context, snapshot) {
            return _bodyList;
          }),
    );
  }
}

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
      {'name': 'اوف لاين', 'image': 'assets/images/wifi-off.svg'},
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

class CardView extends StatelessWidget {
  final Map<String, dynamic> card;
  final AnimationController animationController;
  final Animation<double> animation;
  const CardView({
    required this.card,
    required this.animationController,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => FadeTransition(
        opacity: animation,
        child: RotationTransition(
          turns: animation,
          child: InkWell(
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
          ),
        ),
      ),
    );
  }
}
