import 'package:flutter/material.dart';
import '/providers/bill_provider.dart';
import '/models/bill.dart';
import '/widget/dialog_title.dart';

class CustomBottomSheet extends StatelessWidget {
  final Bill bill;
  final Widget textField;
  final Widget saveBtn;
  const CustomBottomSheet({
    required this.bill,
    required this.textField,
    required this.saveBtn,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.18),
              blurRadius: 30,
            )
          ],
        ),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                DialogTitle(name: 'الإجمالى: '),
                Text('${BillProvider.sumTotal(bill)}'),
              ],
            ),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                DialogTitle(name: 'المدفوع: '),
                const SizedBox(width: 5),
                SizedBox(
                  width: 80,
                  height: 50,
                  child: textField,
                ),
                Expanded(child: SizedBox()),
                Text('${bill.paid}'),
              ],
            ),
            Divider(color: Colors.amber),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                DialogTitle(name: 'ألباقى: '),
                Text('${BillProvider.getRemaining(bill)}'),
              ],
            ),
            const SizedBox(height: 5),
            saveBtn,
          ],
        ),
      ),
    );
  }
}
