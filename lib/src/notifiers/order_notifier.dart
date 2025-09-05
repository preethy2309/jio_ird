import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/providers/external_providers.dart';

import '../data/models/dish_with_quantity.dart';
import '../notifiers/cart_notifier.dart';
import '../providers/data_repository_provider.dart';
import '../providers/state_provider.dart';
import '../utils/util.dart';

class OrderNotifier extends AutoDisposeNotifier<AsyncValue<String>> {
  @override
  AsyncValue<String> build() => const AsyncValue.data("");

  Future<void> placeOrder(List<DishWithQuantity> items) async {
    state = const AsyncValue.loading();

    final repo = ref.read(dataRepositoryProvider);
    final serialNum = ref.read(serialNumberProvider);
    final roomNo = ref.read(guestDetailsProvider).roomNo;

    final orderRequest = createOrderRequestFromDishWithQuantity(
      items,
      serialNum,
      roomNo,
    );

    try {
      final response = await repo.placeOrder(orderRequest);

      if (response['status'] == 200) {
        ref.read(itemQuantitiesProvider.notifier).clearCart();
        ref.read(orderPlacedProvider.notifier).state = true;

        state = AsyncValue.data(response['response'] ?? "Order placed");
      } else {
        state = AsyncValue.error(
          response['response'] ?? "Failed to place order",
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final orderNotifierProvider =
    AutoDisposeNotifierProvider<OrderNotifier, AsyncValue<String>>(
  OrderNotifier.new,
);
