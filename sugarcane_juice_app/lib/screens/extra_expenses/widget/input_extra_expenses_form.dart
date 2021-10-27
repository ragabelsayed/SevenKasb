import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import '/config/palette.dart';
import '/models/extra_expenses.dart';
import '/config/constants.dart';
import '/widget/save_cancel_btns.dart';

class InputExtraExpensesForm extends StatefulWidget {
  final Function(bool extraExpensesError) hasError;
  const InputExtraExpensesForm({required this.hasError});

  @override
  State<InputExtraExpensesForm> createState() => _InputExtraExpensesFormState();
}

class _InputExtraExpensesFormState extends State<InputExtraExpensesForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? date;

  bool _iswaiting = false;
  Extra _extra = Extra(
    reason: '',
    cash: 0.0,
    dataTime: DateTime.now(),
  );

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();

      try {
        widget.hasError(false);
        Navigator.of(context).pop();
      } catch (e) {
        widget.hasError(true);
        Navigator.of(context).pop();
      }
    }
  }

  void setWaiting() {
    setState(() {
      _iswaiting = !_iswaiting;
    });
  }

  String getText() {
    if (date == null) {
      _extra.dataTime = DateTime.now();
      return intl.DateFormat.yMd().format(DateTime.now());
    } else {
      _extra.dataTime = date!;
      return '${intl.DateFormat.yMd().format(date!)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'إضافة مصروفات إضافية',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              hintText: '    سبب المصروف الاضافي',
              error: AppConstants.extraReasonError,
              type: TextInputType.name,
              action: TextInputAction.next,
              onSave: (value) {
                _extra.reason = value;
              },
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              hintText: '    كمية المصروف',
              error: AppConstants.extraCashError,
              type: TextInputType.number,
              action: TextInputAction.done,
              onSave: (value) {
                _extra.cash = double.parse(value);
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  getText(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.calendarAlt,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _pickDate(context);
                  },
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SaveAndCancelBtns(onSave: () {
                  // setWaiting();
                  _saveForm();
                }),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

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

  TextFormField _buildTextFormField({
    required String hintText,
    required String error,
    required TextInputType type,
    required TextInputAction action,
    required Function(String) onSave,
  }) {
    return TextFormField(
      keyboardType: type,
      textInputAction: action,
      textDirection: TextDirection.rtl,
      maxLines: null,
      // textAlign: TextAlign.center,
      decoration: InputDecoration(
        fillColor: Palette.primaryLightColor,
        filled: true,
        hintText: hintText,
        hintMaxLines: 1,
        hintTextDirection: TextDirection.rtl,
        border: AppConstants.border,
        errorBorder: AppConstants.errorBorder,
        focusedBorder: AppConstants.focusedBorder,
      ),
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
