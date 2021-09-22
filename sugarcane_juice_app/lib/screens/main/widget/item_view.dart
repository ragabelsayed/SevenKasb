import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/widget/rounded_text_btn.dart';

class ItemView extends StatefulWidget {
  final Item item;
  const ItemView({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final _form = GlobalKey<FormState>();
  bool _isModfiy = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: !_isModfiy
            ? MediaQuery.of(context).size.height / 2
            : MediaQuery.of(context).size.height / 2 + 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: !_isModfiy ? _getShow(context) : _getForm(),
        ),
      ),
    );
  }

  Form _getForm() => Form(
        key: _form,
        child: ListView(
          children: [
            _buildTitle(context, 'اسم الصنف:'),
            TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              decoration: InputDecoration(
                fillColor: Palette.primaryLightColor,
                filled: true,
                border: AppConstants.border,
                errorBorder: AppConstants.errorBorder,
                focusedBorder: AppConstants.focusedBorder,
              ),
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return 'Please enter your name or email';
                }
              },
              initialValue: '${widget.item.name}',
              onSaved: (newValue) {
                // userData['name'] = newValue!;
              },
            ),
            // SizedBox(height: 10),
            _buildTitle(context, 'السعر:'),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              decoration: InputDecoration(
                fillColor: Palette.primaryLightColor,
                filled: true,
                border: AppConstants.border,
                errorBorder: AppConstants.errorBorder,
                focusedBorder: AppConstants.focusedBorder,
              ),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  // return 'Please enter your password';
                }
              },
              initialValue: '${widget.item.price}',
              onSaved: (newValue) {
                // userData['password'] = newValue!;
              },
            ),
            _buildTitle(context, 'الكمية:'),
            TextFormField(
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.rtl,
              readOnly: true,
              decoration: InputDecoration(
                fillColor: Palette.primaryLightColor,
                filled: true,
                border: AppConstants.border,
                errorBorder: AppConstants.errorBorder,
                focusedBorder: AppConstants.focusedBorder,
              ),
              initialValue: '${widget.item.quentity}',
            ),
            _buildTitle(context, 'وحدة القياس:'),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                fillColor: Palette.primaryLightColor,
                filled: true,
                border: AppConstants.border,
                errorBorder: AppConstants.errorBorder,
                focusedBorder: AppConstants.focusedBorder,
              ),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  // return 'Please enter your password';
                }
              },
              initialValue: '${widget.item.unit.name}',
              onSaved: (newValue) {
                // userData['password'] = newValue!;
              },
            ),
            const SizedBox(height: 20),
            _getBtn(context),
          ],
        ),
      );
  Text _buildTitle(BuildContext context, String? name) {
    return Text.rich(
      TextSpan(
        text: name,
        style: Theme.of(context)
            .textTheme
            .merge(
              TextTheme(
                headline6: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
            .headline6,
      ),
      textDirection: TextDirection.rtl,
    );
  }

  Column _getShow(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Center(
          child: Text(
            'Alasra',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              ' :رقم الصنف',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '${widget.item.id}',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              ' :اسم الصنف',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '${widget.item.name}',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              ' :وحدة القياس',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '${widget.item.unit.name}',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              ':السعر',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '${widget.item.price}',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              ' :الكمية',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '${widget.item.quentity}',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        _getBtn(context),
      ],
    );
  }

  Row _getBtn(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Palette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                  ),
                )),
            child: Text('غلق'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Palette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                )),
            child: !_isModfiy ? Text('تعديل') : Text('حفظ'),
            onPressed: !_isModfiy
                ? () {
                    setState(() => _isModfiy = !_isModfiy);
                  }
                : () {
                    setState(() => _isModfiy = !_isModfiy);
                  },
          ),
        ),
      ],
    );
  }
}
