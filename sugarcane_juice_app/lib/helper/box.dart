import 'package:hive_flutter/hive_flutter.dart';
import '/models/bill.dart';
import '/models/extra_expenses.dart';

class Boxes {
  static Box<Bill> getBillsBox() => Hive.box<Bill>('bills');
  static Box<Extra> getExtraExpensessBox() => Hive.box<Extra>('extraExpenses');
}
