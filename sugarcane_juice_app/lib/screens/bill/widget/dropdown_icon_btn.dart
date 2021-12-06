import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '/config/constants.dart';
import '/config/palette.dart';
import '/models/item.dart';
import '/providers/item_provider.dart';

class DropdownIconBtn extends ConsumerWidget {
  const DropdownIconBtn({
    Key? key,
    required this.dropdownValue,
    required this.conroller,
    required this.onSave,
  }) : super(key: key);
  final Function(Item dropdownItemValue) dropdownValue;
  final Function(String) onSave;
  final TextEditingController conroller;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<Item> itemList = watch(itemProvider).items;
    return TypeAheadFormField<Item?>(
      suggestionsCallback: (pattern) => itemList
          .where((item) => '${item.unit.name} ${item.name}'.contains(pattern))
          .toList(),
      itemBuilder: (context, itemData) => Text(
        '${itemData!.unit.name} ${itemData.name}',
        textAlign: TextAlign.center,
      ),
      onSuggestionSelected: (Item? _item) {
        conroller.text = '${_item!.unit.name} ${_item.name}';
        dropdownValue(_item);
      },
      validator: (newValue) {
        if (newValue!.isEmpty) {
          return AppConstants.nameError;
        }
      },
      onSaved: (newValue) {},
      noItemsFoundBuilder: (context) => SizedBox(
        height: 50,
        child: Center(
          child: Text(
            '!لا يوجد صنف بهذا الإسم برجاء إضافتها أولًا',
            style: TextStyle(
                color: Colors.red.shade300, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      debounceDuration: const Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        controller: conroller,
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          fillColor: Palette.primaryLightColor,
          filled: true,
          hintText: 'إختار الصنف',
          hintMaxLines: 1,
          hintTextDirection: TextDirection.rtl,
          suffixIcon: const Icon(
            Icons.search,
            color: Palette.primaryColor,
          ),
          border: AppConstants.border,
          errorBorder: AppConstants.errorBorder,
          focusedBorder: AppConstants.focusedBorder,
        ),
      ),
    );
  }
}
