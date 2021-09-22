import 'package:flutter/material.dart';

class IputItemForm extends StatefulWidget {
  const IputItemForm({Key? key}) : super(key: key);

  @override
  _IputItemFormState createState() => _IputItemFormState();
}

class _IputItemFormState extends State<IputItemForm> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}
