import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice_app/helper/box.dart';
import 'package:sugarcane_juice_app/models/bill.dart';
import 'package:sugarcane_juice_app/models/extra_expenses.dart';

final _extraBox = Boxes.getExtraExpensessBox();

final extraOfflineProvider =
    StateNotifierProvider.autoDispose<OfflineExtraNotifier, List<Extra>>(
  (ref) => OfflineExtraNotifier(_extraBox.values.toList()),
);

final billOfflineProvider =
    StateNotifierProvider<OfflineBillNotifier, List<Bill>>(
  (ref) => OfflineBillNotifier([]),
);

class OfflineBillNotifier extends StateNotifier<List<Bill>> {
  OfflineBillNotifier(List<Bill>? initialBills) : super(initialBills ?? []);
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
