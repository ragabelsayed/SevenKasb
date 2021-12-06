import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '/models/user.dart';
import '/providers/offLine_provider.dart';
import '/widget/toast_view.dart';
import '/providers/extra_provider.dart';
import '/config/palette.dart';
import '/models/extra_expenses.dart';
import '/config/constants.dart';
import '/widget/save_cancel_btns.dart';

class InputExtraExpensesForm extends StatefulWidget {
  final FToast ftoast;
  final bool isOffLine;
  const InputExtraExpensesForm(
      {Key? key, required this.ftoast, this.isOffLine = false})
      : super(key: key);
  @override
  State<InputExtraExpensesForm> createState() => _InputExtraExpensesFormState();
}

class _InputExtraExpensesFormState extends State<InputExtraExpensesForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? date;
  bool _iswaiting = false;
  final Extra _extra = Extra(
    user: User(),
    reason: '',
    cash: 0.0,
    dataTime: DateTime.now(),
  );

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      try {
        await context
            .read(addExtraExpensesProvider)
            .addExtra(extra: _extra, fToast: widget.ftoast, context: context);
        // _toast(' تم اضافة المصروف', true);
        Navigator.of(context).pop();
        _toast('اسحب لأسفل للتحديث', true);
      } catch (e) {
        _toast('لم تتم إضافةُ المصروف', false);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _saveFormOffline() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      try {
        await context.read(extraOfflineProvider.notifier).addExtra(_extra);
        _toast('تم إضافة المصروف', true);
        Navigator.of(context).pop();
      } catch (e) {
        _toast('لم تتم إضافةُ المصروف', false);
        Navigator.of(context).pop();
      }
    }
  }

  void _toast(String message, bool success) {
    widget.ftoast.showToast(
      child: ToastView(
        message: message,
        success: success,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
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
      return intl.DateFormat.yMd().format(date!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _iswaiting
        ? SizedBox(
            height: 100,
            width: double.infinity,
            child: FutureBuilder(
              future: widget.isOffLine ? _saveFormOffline() : _saveForm(),
              builder: (context, snapshot) => const Center(
                child: CircularProgressIndicator(
                  color: Palette.primaryColor,
                  backgroundColor: Palette.primaryLightColor,
                ),
              ),
            ),
          )
        : Padding(
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
                    hintText: '    كمية المصروف',
                    error: AppConstants.extraCashError,
                    type: TextInputType.number,
                    isNamberOnly: true,
                    action: TextInputAction.done,
                    onSave: (value) {
                      _extra.cash = double.parse(value);
                    },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        getText(),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      IconButton(
                        icon: const FaIcon(
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
                      SaveAndCancelBtns(onSave: () => setWaiting()),
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
    bool isNamberOnly = false,
    required TextInputAction action,
    required Function(String) onSave,
  }) {
    return TextFormField(
      keyboardType: type,
      textInputAction: action,
      textDirection: TextDirection.rtl,
      maxLines: null,
      // textAlign: TextAlign.center,
      inputFormatters: isNamberOnly
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))]
          : null,
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
