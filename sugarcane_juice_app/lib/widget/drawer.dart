import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTileView(
            icon: Icons.exit_to_app,
            title: 'Log Out',
            onTap: () {
              context.read(authProvider).logOut();
            },
          ),
        ],
      ),
    );
  }
}

class ListTileView extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  const ListTileView({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}
