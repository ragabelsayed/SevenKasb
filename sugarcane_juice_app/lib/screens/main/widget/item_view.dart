import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/widget/dialog_btns.dart';
import 'package:sugarcane_juice_app/widget/dialog_title.dart';

class ItemView extends StatefulWidget {
  final Item item;
  const ItemView({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final _formKey = GlobalKey<FormState>();
  bool _isModfiy = false;

  void _saveForm() {
    final _isValid = _formKey.currentState!.validate();
    // if (_isValid) {
    //   _formKey.currentState!.save();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: !_isModfiy ? _getShow(context) : _getForm(),
      ),
    );
  }

  Form _getForm() => Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            DialogTitle(name: 'اسم الصنف:'),
            _buildTextFormField(
              initialValue: '${widget.item.name}',
              error: AppConstants.nameError,
              type: TextInputType.name,
              action: TextInputAction.next,
            ),
            DialogTitle(name: 'السعر:'),
            _buildTextFormField(
              initialValue: '${widget.item.price}',
              error: AppConstants.priceError,
              type: TextInputType.number,
              action: TextInputAction.next,
            ),
            DialogTitle(name: 'الكمية:'),
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
            DialogTitle(name: 'وحدة القياس:'),
            _buildTextFormField(
              initialValue: '${widget.item.unit.name}',
              error: AppConstants.unitError,
              type: TextInputType.emailAddress,
              action: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            if (_isModfiy)
              DialogButtons(
                name: 'حفظ',
                onPressed: () {
                  _saveForm();
                  setState(() => _isModfiy = !_isModfiy);
                },
              ),
          ],
        ),
      );

  Widget _getShow(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
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
          if (!_isModfiy)
            DialogButtons(
              name: 'تعديل',
              onPressed: () {
                setState(() => _isModfiy = !_isModfiy);
              },
            ),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String initialValue,
    required String error,
    required TextInputType type,
    required TextInputAction action,
  }) {
    return TextFormField(
      keyboardType: type,
      textInputAction: action,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      decoration: InputDecoration(
        fillColor: Palette.primaryLightColor,
        filled: true,
        border: AppConstants.border,
        errorBorder: AppConstants.errorBorder,
        focusedBorder: AppConstants.focusedBorder,
      ),
      initialValue: initialValue,
      onFieldSubmitted: (value) {
        if (value.isNotEmpty) {
          _formKey.currentState!.validate();
        }
      },
      validator: (newValue) {
        if (newValue!.isEmpty) {
          return error;
        }
      },
      onSaved: (newValue) {
        // userData['name'] = newValue!;
      },
    );
  }
}
