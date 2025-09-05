import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/cart_notifier.dart';
import '../../providers/focus_provider.dart';
import '../../providers/state_provider.dart';
import '../widgets/cart/bill_summary.dart';
import '../widgets/cart/cart_empty.dart';
import '../widgets/cart/cart_item_list.dart';
import '../widgets/cart/order_placed.dart';
import '../widgets/cart/tab_switcher.dart';
import '../widgets/my_orders/my_order_list.dart';
import 'base_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedCartTabProvider);
    final orderPlaced = ref.watch(orderPlacedProvider);

    final cartItems = ref.watch(itemQuantitiesProvider);

    void onTrackOrderPressed() {
      ref.read(selectedCartTabProvider.notifier).state = CartTab.orders;
      final infoTabFocusNode = ref.read(myOrdersTabFocusNodeProvider);
      infoTabFocusNode.requestFocus();
      ref.read(orderPlacedProvider.notifier).state = false;
    }

    return BaseScreen(
      title: "Cart",
      child: SafeArea(
        child: Column(
          children: [
            const TabSwitcher(),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: (selectedTab == CartTab.cart
                    ? (orderPlaced
                        ? OrderPlaced(onTrackOrder: onTrackOrderPressed)
                        : (cartItems.isEmpty
                            ? const Center(
                                child: EmptyCartScreen(title: "Empty Cart"),
                              )
                            : const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: CartItemsList(),
                                  ),
                                  SizedBox(width: 32),
                                  Expanded(
                                    flex: 3,
                                    child: BillSummaryScreen(),
                                  ),
                                ],
                              )))
                    : const MyOrderList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
