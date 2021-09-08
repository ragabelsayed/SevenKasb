import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routName = '/home';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
    );
  }
}
