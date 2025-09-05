import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/ui/widgets/my_order_shimmer.dart';

import '../../../data/models/order_status_response.dart';
import '../../../providers/state_provider.dart';
import '../../screens/order_detail_screen.dart';
import '../cart/cart_empty.dart';
import 'order_info.dart';

class MyOrderList extends ConsumerStatefulWidget {
  const MyOrderList({super.key});

  @override
  ConsumerState<MyOrderList> createState() => _MyOrderListState();
}

class _MyOrderListState extends ConsumerState<MyOrderList> {
  int? focusedIndex;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.refresh(orderStatusProvider));
  }

  @override
  Widget build(BuildContext context) {
    final orderStatusAsync = ref.watch(orderStatusProvider);

    return orderStatusAsync.when(
      loading: () => const MyOrdersShimmer(),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (orders) {
        if (orders.isEmpty) {
          return const EmptyCartScreen(title: "No Orders");
        }

        return Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              setState(() => focusedIndex = null);
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final action = _getOrderAction(order.dishDetails);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Focus(
                  canRequestFocus: true,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      setState(() => focusedIndex = index);
                    }
                  },
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    ),
                    child: _orderTile(
                      orderNo: order.orderId.toString(),
                      billDetails: '${order.dishDetails.length} Items',
                      toPay: '₹ ${_calculateTotal(order.dishDetails)}',
                      isActive: focusedIndex == index,
                      isButton: action.isButton,
                      buttonText: action.buttonText,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _mapStatus(String? status) {
    switch (status?.toLowerCase()) {
      case "submitted":
        return "Submitted";
      case "accepted":
        return "Accepted";
      case "preparing":
      case "in progress":
        return "Preparing";
      case "delivered":
      case "served":
        return "Served";
      case "cancelled":
        return "Cancelled";
      default:
        return status ?? "";
    }
  }

  _OrderAction _getOrderAction(List<OrderDishDetail> dishes) {
    final statuses = dishes.map((d) => _mapStatus(d.status)).toList();
    final allServed = statuses.every((s) => s == "Served");
    final allCancelled = statuses.every((s) => s == "Cancelled");

    if (allServed) return _OrderAction("Order Served!", false);
    if (allCancelled) return _OrderAction("Order Cancelled!", false);
    return _OrderAction("Track Order", true);
  }

  String _calculateTotal(List<OrderDishDetail> dishes) {
    final total = dishes.fold<double>(
      0,
      (sum, dish) =>
          sum + (double.tryParse(dish.price.toString()) ?? 0) * dish.quantity,
    );
    return total.toStringAsFixed(0);
  }

  Widget _orderTile({
    required String orderNo,
    required String billDetails,
    required String toPay,
    bool isActive = false,
    required String buttonText,
    bool isButton = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.secondary
            : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 100),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OrderInfo(
              orderNo: orderNo,
              billDetails: billDetails,
              toPay: toPay,
              isActive: isActive),
          isButton
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isActive
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(buttonText),
                )
              : Text(
                  buttonText,
                  style: TextStyle(
                      color: isActive
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.white38),
                ),
        ],
      ),
    );
  }
}

class _OrderAction {
  final String buttonText;
  final bool isButton;

  _OrderAction(this.buttonText, this.isButton);
}
