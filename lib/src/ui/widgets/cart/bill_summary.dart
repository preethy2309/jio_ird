import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notifiers/cart_notifier.dart';
import '../../../notifiers/order_notifier.dart';
import '../../../providers/focus_provider.dart';

class BillSummaryScreen extends ConsumerWidget {
  const BillSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemQuantitiesProvider);
    final placeOrderFocusNode = ref.watch(placeOrderFocusNodeProvider);

    final totalPrice = items.fold<double>(
      0,
      (sum, dishWithQty) {
        final price = double.tryParse(dishWithQty.dish.dishPrice) ?? 0.0;
        return sum + price * dishWithQty.quantity;
      },
    );

    final int itemCount = items.length;
    final double itemTotal = totalPrice;
    final double toPay = itemTotal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bill details',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Text(
                '$itemCount Items',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          if (itemTotal > 0) ...[
            const SizedBox(height: 16),

            // Item total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Item Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹ $itemTotal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            const Divider(color: Colors.white38),

            // To Pay
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'To Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹ ${toPay.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white38),
          ],

          const SizedBox(height: 12),

          // Place order button
          SizedBox(
            width: 160,
            child: Focus(
              canRequestFocus: true,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  ref.read(cartTabFocusNodeProvider).requestFocus();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: ElevatedButton(
                focusNode: placeOrderFocusNode,
                onPressed: () {
                  ref.read(orderNotifierProvider.notifier).placeOrder(items);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.focused)) {
                        return Theme.of(context).primaryColor;
                      }
                      return Colors.white;
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.focused)) {
                        return Theme.of(context).colorScheme.onPrimary;
                      }
                      return Theme.of(context).colorScheme.onSecondary;
                    },
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    final orderState = ref.watch(orderNotifierProvider);

                    return orderState.when(
                      loading: () => const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      data: (msg) {
                        if (msg.isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(msg),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          });
                        }
                        return const Text("Place Order");
                      },
                      error: (err, _) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(err.toString()),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        });
                        return const Text("Retry Order");
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          if (itemTotal > 0) ...[
            const Text(
              'This order will be included in Bill',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
