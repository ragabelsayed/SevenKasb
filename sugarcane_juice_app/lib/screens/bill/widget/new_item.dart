import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/item.dart';
import '/models/unit.dart';
import '/providers/item_provider.dart';
import '/providers/unit_provider.dart';
import '/widget/save_cancel_btns.dart';
import '/widget/toast_view.dart';

class NewItem extends StatelessWidget {
  const NewItem({Key? key, required this.ftoast}) : super(key: key);
  final FToast ftoast;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'إضافة صنف جديد',
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ItemForm(ftoast: ftoast),
        );
      },
    );
  }
}

class ItemForm extends StatefulWidget {
  const ItemForm({Key? key, required this.ftoast}) : super(key: key);
  final FToast ftoast;
  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController unitController = TextEditingController();
  late Item _item;
  bool _iswaiting = false;

  @override
  void initState() {
    super.initState();
    _item = Item(name: '', unit: Unit(name: ''));
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      setWaiting();
      try {
        if (_item.unit.id != null) {
          await context.read(itemProvider).addItem(_item);
          _toast('تم إضافة الصنف بنجاح', true);
          Navigator.of(context).pop();
        } else {
          final newUnit = await context.read(unitProvider).addUnit(_item.unit);
          _item.unit = newUnit;
          await context.read(itemProvider).addItem(_item);
          _toast('تم إضافة الصنف بنجاح', true);
          Navigator.of(context).pop();
        }
      } catch (e) {
        _toast('لم تتم إضافة الصنف', false);
        Navigator.of(context).pop();
      }
    }
  }

  void _toast(String masseg, bool succes) {
    widget.ftoast.showToast(
      child: ToastView(
        message: masseg,
        success: succes,
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void setWaiting() => setState(() => _iswaiting = !_iswaiting);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _iswaiting ? Colors.transparent : null,
      elevation: _iswaiting ? 0.0 : null,
      child: _iswaiting
          ? const Center(
              child: CircularProgressIndicator(
                color: Palette.primaryColor,
                backgroundColor: Palette.primaryLightColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'إضافة صنف',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 10),
                    _buildTextFormField(
                      hintText: '    اسم الصنف',
                      error: AppConstants.nameError,
                      action: TextInputAction.next,
                      onSave: (value) {
                        _item.name = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextFormField(
                      hintText: '    وحدة القياس',
                      error: AppConstants.unitError,
                      action: TextInputAction.done,
                      unitController: unitController,
                      readOnly: _item.unit.id != null ? true : false,
                      dropDown: DropDownUnit(
                        dropdownValue: (dropdownUnitValue) {
                          unitController.text = dropdownUnitValue!.name;
                          setState(() => _item.unit = dropdownUnitValue);
                        },
                      ),
                      onSave: (value) => _item.unit.name = value,
                    ),
                    const SizedBox(height: 30),
                    SaveAndCancelBtns(onSave: () => _saveForm())
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField _buildTextFormField({
    required String hintText,
    required String error,
    required TextInputAction action,
    bool readOnly = false,
    TextEditingController? unitController,
    Widget? dropDown,
    required Function(String) onSave,
  }) {
    return TextFormField(
      controller: unitController,
      textInputAction: action,
      keyboardType: TextInputType.emailAddress,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      // textAlign: TextAlign.center,
      decoration: InputDecoration(
        fillColor: Palette.primaryLightColor,
        filled: true,
        hintText: hintText,
        hintMaxLines: 1,
        suffixIcon: dropDown,
        hintTextDirection: TextDirection.rtl,
        border: AppConstants.border,
        errorBorder: AppConstants.errorBorder,
        focusedBorder: AppConstants.focusedBorder,
      ),
      readOnly: readOnly,
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
}

class DropDownUnit extends ConsumerWidget {
  const DropDownUnit({Key? key, required this.dropdownValue}) : super(key: key);
  final Function(Unit? dropdownUnitValue) dropdownValue;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<Unit> unitList = watch(unitProvider).items;
    return PopupMenuButton<Unit>(
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.amber,
      ),
      onSelected: (value) {
        dropdownValue(value);
      },
      itemBuilder: (BuildContext context) => unitList
          .map<PopupMenuItem<Unit>>(
            (unit) => PopupMenuItem(child: Text(unit.name), value: unit),
          )
          .toList(),
    );
  }
}
