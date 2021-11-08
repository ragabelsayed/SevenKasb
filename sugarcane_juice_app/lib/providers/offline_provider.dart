import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/helper/box.dart';
import '/models/bill.dart';
import '/models/extra_expenses.dart';

final _extraBox = Boxes.getExtraExpensessBox();
final _billBox = Boxes.getBillsBox();

final extraOfflineProvider =
    StateNotifierProvider.autoDispose<OfflineExtraNotifier, List<Extra>>(
  (ref) => OfflineExtraNotifier(_extraBox.values.toList()),
);

final billOfflineProvider =
    StateNotifierProvider.autoDispose<OfflineBillNotifier, List<Bill>>(
  (ref) => OfflineBillNotifier(_billBox.values.toList()),
);

class OfflineBillNotifier extends StateNotifier<List<Bill>> {
  OfflineBillNotifier(List<Bill>? initialBills) : super(initialBills ?? []);

  Future<void> addBill(Bill bill) async {
    state.add(bill);
    await _billBox.add(bill);
  }

  Future<void> removeBill() async {
    state.clear();
    await _billBox.clear();
  }
}

class OfflineExtraNotifier extends StateNotifier<List<Extra>> {
  OfflineExtraNotifier(List<Extra>? initialExtras) : super(initialExtras ?? []);

  Future<void> addExtra(Extra extra) async {
    state.add(extra);
    await _extraBox.add(extra);
  }

  Future<void> removeExtra() async {
    state.clear();
    await _extraBox.clear();
  }
}
