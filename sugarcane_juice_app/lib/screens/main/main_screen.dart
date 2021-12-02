import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/providers/item_provider.dart';
import '/providers/unit_provider.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import 'widget/card_list.dart';

class MainScreen extends StatefulWidget {
  static const routName = '/main_screen';
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
    _bodyList = CardList(controller: _animationController, isList: _isList);
    Future.delayed(Duration.zero, () {
      context.read(unitProvider).fetchAndSetData();
      context.read(itemProvider).fetchAndSetData();
    });
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
        title: const Text(
          'سڤن قصب',
          textDirection: TextDirection.rtl,
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        leading: const SizedBox(),
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
                  _bodyList = CardList(
                    controller: _animationController,
                    isList: _isList,
                  );
                });
              });
            },
          ),
        ],
        shape: AppConstants.appBarBorder,
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) => _bodyList,
      ),
    );
  }
}
