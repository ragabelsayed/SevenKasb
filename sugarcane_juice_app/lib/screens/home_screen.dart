import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/widget/drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routName = '/home';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(),
    );
  }
}
