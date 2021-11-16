import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/config/palette.dart';
import '/config/routes.dart';
import '/screens/home_screen.dart';
import '/widget/dialog_title.dart';

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
