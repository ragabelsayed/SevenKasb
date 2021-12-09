import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/inventory.dart';
import '/providers/inventory_povider.dart';
import '/widget/toast_view.dart';
import '/config/palette.dart';
import 'package:intl/intl.dart' as intl;

const double btnSize = 60.0;

class LinearFlowWidget extends StatefulWidget {
  final FToast fToast;
  final InventoryType inventoryType;
  const LinearFlowWidget(
      {Key? key, required this.fToast, required this.inventoryType})
      : super(key: key);
  @override
  State<LinearFlowWidget> createState() => _LinearFlowWidgetState();
}

class _LinearFlowWidgetState extends State<LinearFlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Map<String, Widget> btns;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    btns = {
      'btn1': Text(
        'شهري',
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: Colors.white),
      ),
      'btn2': Text(
        'يومي',
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: Colors.white),
      ),
    };
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toast(String message, bool success) {
    widget.fToast.showToast(
      child: ToastView(
        message: message,
        success: success,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: Clip.none,
      delegate: FlowMenuDelegate(myAnimation: controller),
      children: [
        Icons.add,
        Icons.calendar_view_month,
        Icons.calendar_view_day,
      ].map(buildFAB).toList(),
    );
  }

  Widget buildFAB(IconData icon) => SizedBox(
        width: btnSize,
        height: btnSize,
        child: FloatingActionButton(
          heroTag: icon.toString(),
          splashColor: Colors.green,
          backgroundColor: Colors.amber,
          child: icon == Icons.add
              ? Icon(icon, size: 25)
              : icon == Icons.calendar_view_month
                  ? btns['btn1']
                  : btns['btn2'],
          onPressed: () async {
            //   if (controller.status == AnimationStatus.completed) {
            //     controller.reverse();
            //   } else {
            //     controller.forward();
            //   }
            //   if (icon == Icons.calendar_view_month) {
            //     await _pickDate(context);
            //     if (widget.inventoryType == InventoryType.purchase) {
            //       try {
            //         await context
            //             .read(inventoryPurchasesProvider.notifier)
            //             .getInventory(
            //               year: intl.DateFormat.y().format(date),
            //               month: intl.DateFormat.M().format(date),
            //               inventoryType: InventoryType.monthly,
            //             );
            //         _toast('تم جلب الجرد الشهري', true);
            //       } catch (e) {
            //         _toast('لم يتم جلب الجرد الشهري', false);
            //       }
            //     }
            //     if (widget.inventoryType == InventoryType.sales) {
            //       try {
            //         await context
            //             .read(inventorySalesProvider.notifier)
            //             .getInventory(
            //               year: intl.DateFormat.y().format(date),
            //               month: intl.DateFormat.M().format(date),
            //               inventoryType: InventoryType.monthly,
            //             );
            //         _toast('تم جلب الجرد الشهري', true);
            //       } catch (e) {
            //         _toast('لم يتم جلب الجرد الشهري', false);
            //       }
            //     }
            //   }
            //   if (icon == Icons.calendar_view_day) {
            //     await _pickDate(context);
            //     if (widget.inventoryType == InventoryType.purchase) {
            //       try {
            //         await context
            //             .read(inventoryPurchasesProvider.notifier)
            //             .getInventory(
            //               day: intl.DateFormat.yMd()
            //                   .format(date)
            //                   .replaceAll(RegExp(r'/'), '-'),
            //               inventoryType: InventoryType.daily,
            //             );
            //         _toast('تم جلب الجرد اليومي', true);
            //       } catch (e) {
            //         _toast('لم يتم جلب الجرد اليومي', false);
            //       }
            //     }
            //     if (widget.inventoryType == InventoryType.sales) {
            //       try {
            //         await context
            //             .read(inventorySalesProvider.notifier)
            //             .getInventory(
            //               day: intl.DateFormat.yMd()
            //                   .format(date)
            //                   .replaceAll(RegExp(r'/'), '-'),
            //               inventoryType: InventoryType.daily,
            //             );
            //         _toast('تم جلب الجرد اليومي', true);
            //       } catch (e) {
            //         _toast('لم يتم جلب الجرد اليومي', false);
            //       }
            //     }
            //   }
          },
        ),
      );
  Future<DateTime?> _pickDate(BuildContext context) async {
    final initalDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initalDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      // textDirection: TextDirection.rtl,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Palette.primaryColor,
              secondary: Palette.primaryLightColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      setState(() {
        date = newDate;
      });
    }
  }
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
