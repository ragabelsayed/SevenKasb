import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sugarcane_juice_app/config/constants.dart';
import 'package:sugarcane_juice_app/config/palette.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/providers/item_provider.dart';
import 'package:sugarcane_juice_app/providers/unit_provider.dart';
import 'package:sugarcane_juice_app/screens/main/widget/dropdown_unit_btn.dart';
import 'package:sugarcane_juice_app/screens/main/widget/type_toggle_btn.dart';
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
    if (_isValid) {
      _formKey.currentState!.save();
      context.read(itemProvider).updateItem(newItem: widget.item);
      Navigator.of(context).pop();
    }
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
              onSave: (value) => widget.item.name = value,
            ),
            DialogTitle(name: 'السعر:'),
            _buildTextFormField(
              initialValue: '${widget.item.price}',
              error: AppConstants.priceError,
              type: TextInputType.number,
              action: TextInputAction.next,
              onSave: (value) => widget.item.price = value,
            ),
            // DialogTitle(name: 'الكمية:'),
            // TextFormField(
            //   textInputAction: TextInputAction.next,
            //   textDirection: TextDirection.rtl,
            //   readOnly: true,
            //   decoration: InputDecoration(
            //     fillColor: Palette.primaryLightColor,
            //     filled: true,
            //     border: AppConstants.border,
            //     errorBorder: AppConstants.errorBorder,
            //     focusedBorder: AppConstants.focusedBorder,
            //   ),
            //   initialValue: '${widget.item.quentity}',
            // ),
            DialogTitle(name: 'وحدة القياس:'),
            // _buildTextFormField(
            //   initialValue: '${widget.item.unit.name}',
            //   error: AppConstants.unitError,
            //   type: TextInputType.emailAddress,
            //   action: TextInputAction.done,
            // ),
            DropdownUnitBtn(
              oldUnit: widget.item.unit,
              unitId: (newUnit) {
                var updateUnit = context
                    .read(unitProvider)
                    .items
                    .firstWhere((unit) => unit.id == newUnit);
                return widget.item.unit = updateUnit;
              },
            ),
            DialogTitle(name: 'نوع الصنف: '),
            const SizedBox(height: 15),
            TypeToggleBtn(
              oldType: widget.item.type,
              itemType: (type) => widget.item.type = type,
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
              'الصنف',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(height: 20),
          _buildItemRow(name: ' :رقم الصنف', value: '${widget.item.id}'),
          const SizedBox(height: 5),
          _buildItemRow(name: ' :اسم الصنف', value: '${widget.item.name}'),
          const SizedBox(height: 5),
          _buildItemRow(
              name: ' :وحدة القياس', value: '${widget.item.unit.name}'),
          const SizedBox(height: 5),
          _buildItemRow(name: ':السعر', value: '${widget.item.price}'),
          const SizedBox(height: 5),
          _buildItemRow(name: ' :الكمية', value: '${widget.item.quentity}'),
          const Expanded(child: SizedBox()),
          if (!_isModfiy)
            DialogButtons(
              name: 'تعديل',
              idDeleted: true,
              deleteItem: widget.item,
              onPressed: () {
                setState(() => _isModfiy = !_isModfiy);
              },
            ),
        ],
      ),
    );
  }

  Row _buildItemRow({required String name, required String value}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            name,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      );

  TextFormField _buildTextFormField({
    required String initialValue,
    required String error,
    required TextInputType type,
    required TextInputAction action,
    required Function(String) onSave,
  }) =>
      TextFormField(
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
        onSaved: (newValue) => onSave(newValue!),
      );
}
