import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/widget/menu_widget.dart';

const double btnSize = 70.0;

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أوف لاين',
          style: AppConstants.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Palette.primaryColor,
        leading: MenuWidget(),
        shape: AppConstants.appBarBorder,
      ),
      floatingActionButton: LinearFlowWidget(),
    );
  }
}

class LinearFlowWidget extends StatefulWidget {
  const LinearFlowWidget({Key? key}) : super(key: key);

  @override
  State<LinearFlowWidget> createState() => _LinearFlowWidgetState();
}

class _LinearFlowWidgetState extends State<LinearFlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: Clip.none,
      delegate: FlowMenuDelegate(myAnimation: controller),
      children: [
        FontAwesomeIcons.plus,
        FontAwesomeIcons.receipt,
        FontAwesomeIcons.wallet,
      ].map(buildFAB).toList(),
    );
  }

  Widget buildFAB(IconData icon) => SizedBox(
        width: btnSize,
        height: btnSize,
        child: FloatingActionButton(
          // elevation: 0,
          heroTag: icon.toString(),
          splashColor: Colors.green,
          backgroundColor: Colors.amber,
          child: FaIcon(icon),
          onPressed: () {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else {
              controller.forward();
            }

            if (icon == FontAwesomeIcons.receipt) {
              print('bbbbbbb');
            }
            if (icon == FontAwesomeIcons.wallet) {
              print('mmmmm');
            }
          },
        ),
      );
}

class CircularFabWidget extends StatefulWidget {
  const CircularFabWidget({Key? key}) : super(key: key);

  @override
  State<CircularFabWidget> createState() => _CircularFabWidgetState();
}

class _CircularFabWidgetState extends State<CircularFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: Clip.none,
      delegate: FlowMenuDelegate(myAnimation: controller),
      children: [
        FontAwesomeIcons.receipt,
        FontAwesomeIcons.wallet,
        FontAwesomeIcons.plus,
      ].map(buildFAB).toList(),
    );
  }

  Widget buildFAB(IconData icon) => SizedBox(
        // width: btnSize,
        // height: btnSize,
        child: FloatingActionButton(
          // elevation: 0,
          heroTag: icon.toString(),
          splashColor: Colors.black,
          backgroundColor: Colors.amber,
          child: FaIcon(icon),
          onPressed: () {
            print(1111);
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else {
              controller.forward();
            }
          },
        ),
      );
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> myAnimation;
  const FlowMenuDelegate({required this.myAnimation})
      : super(repaint: myAnimation);

  @override
  void paintChildren(FlowPaintingContext ctx) {
    final size = ctx.size;
    final xStart = size.width - btnSize;
    final yStart = size.height - btnSize;

    final n = ctx.childCount;
    for (int i = n - 1; i >= 0; i--) {
      final margin = 8;
      final childSize = ctx.getChildSize(i)!.width;
      final dx = (childSize + margin) * i;
      final x = xStart;
      final y = yStart - dx * myAnimation.value;

      ctx.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
