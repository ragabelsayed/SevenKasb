import 'package:flutter/material.dart';
import '/config/palette.dart';
import '/widget/alert_view.dart';
import '/widget/dialog_title.dart';
import '/widget/rounded_text_btn.dart';

class ExpansionView extends StatelessWidget {
  final Function onpress;
  final List getList;
  final String title;
  final String subTitle;
  final bool isSending;
  final Function sendToServer;
  const ExpansionView({
    required this.title,
    required this.subTitle,
    required this.onpress,
    required this.getList,
    required this.isSending,
    required this.sendToServer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: DialogTitle(name: title),
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      expandedAlignment: Alignment.center,
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      iconColor: Colors.amber,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      controlAffinity: ListTileControlAffinity.leading,
      maintainState: true,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subTitle,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            CircleAvatar(
              child: Text(
                '${getList.length}',
                style: TextStyle(color: Palette.primaryColor),
              ),
              backgroundColor: Palette.primaryLightColor,
            )
          ],
        ),
        const SizedBox(height: 10),
        if (!isSending)
          RoundedTextButton(
            text: 'إرسال لسيرفر',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertView(
                  isSave: true,
                  message: 'هل أنت متأكد من الحفظ فى السيرفر',
                  onpress: () => onpress(),
                ),
              );
            },
          ),
        if (isSending)
          FutureBuilder(
            future: sendToServer(),
            builder: (context, snapshot) {
              return const CircularProgressIndicator(
                backgroundColor: Palette.primaryLightColor,
                color: Palette.primaryColor,
              );
            },
          ),
      ],
    );
  }
}
