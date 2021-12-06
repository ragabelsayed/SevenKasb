import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/screens/bill/new_bill_screen.dart';
import '/screens/extra_expenses/widget/input_extra_expenses_form.dart';
import '/providers/bill_provider.dart';

const double btnSize = 60.0;

class LinearFlowWidget extends StatefulWidget {
  final FToast fToast;
  const LinearFlowWidget({Key? key, required this.fToast}) : super(key: key);

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
          heroTag: icon.toString(),
          tooltip: icon == FontAwesomeIcons.receipt
              ? 'إضافة فاتورة جديدة'
              : icon == FontAwesomeIcons.wallet
                  ? 'إضافة مصروف إضافي'
                  : null,
          splashColor: Colors.green,
          backgroundColor: Colors.amber,
          child: FaIcon(icon, size: 20),
          onPressed: () {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else {
              controller.forward();
            }
            if (icon == FontAwesomeIcons.receipt) {
              context.read(isOffLineProvider).state = true;
              Navigator.pushNamed(context, NewBillScreen.routName);
            }
            if (icon == FontAwesomeIcons.wallet) {
              showModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                builder: (ctx) => InputExtraExpensesForm(
                  ftoast: widget.fToast,
                  isOffLine: true,
                ),
              );
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
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - btnSize;
    final yStart = size.height - btnSize;

    final n = context.childCount;
    for (int i = n - 1; i >= 0; i--) {
      const margin = 8;
      final childSize = context.getChildSize(i)!.width;
      final dx = (childSize + margin) * i;
      final x = xStart;
      final y = yStart - dx * myAnimation.value;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
