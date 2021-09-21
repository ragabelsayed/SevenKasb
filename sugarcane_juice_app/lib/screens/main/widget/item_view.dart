import 'package:flutter/material.dart';
import 'package:sugarcane_juice_app/models/item.dart';
import 'package:sugarcane_juice_app/widget/rounded_text_btn.dart';

class ItemView extends StatelessWidget {
  final Item item;
  const ItemView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Center(
                child: Text(
                  'Alasra',
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${item.id}',
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${item.name}',
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${item.unit.name}',
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
                    ' :السعر',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${item.price}',
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${item.unit.name}',
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${item.quentity}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              SizedBox(
                height: 50,
                child: RoundedTextButton(
                  text: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
