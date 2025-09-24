import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/order_status_response.dart';
import '../../providers/state_provider.dart';
import '../widgets/my_orders/order_card.dart';
import '../widgets/my_orders/order_info.dart';
import 'base_screen.dart';

class OrderDetailScreen extends ConsumerWidget {
  final int orderId;

  OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  final List<String> _statusOrder = [
    "placed",
    "accepted",
    "preparing",
    "served",
  ];

  int _getStepIndex(String? status) {
    if (status == null) return 0;
    return _statusOrder.indexOf(status.toLowerCase());
  }

  String _calculateTotal(List<OrderDishDetail> dishes) {
    double total = 0;
    for (var dish in dishes) {
      final price = (dish.price is num)
          ? (dish.price as num).toDouble()
          : double.tryParse(dish.price.toString()) ?? 0;
      total += price * dish.quantity;
    }
    return total.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderStatusAsync = ref.watch(orderStatusProvider);

    return orderStatusAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error: $err")),
      data: (orders) {
        final order = orders.firstWhere((o) => o.orderId == orderId);
        return _buildOrderDetail(context, order);
      },
    );
  }

  Widget _buildOrderDetail(BuildContext context, OrderStatusResponse order) {
    return BaseScreen(
      title: "My Order",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderInfo(
              orderNo: order.orderId.toString(),
              billDetails: "${order.dishDetails.length} Items",
              toPay: "₹ ${_calculateTotal(order.dishDetails)}",
              isActive: false,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: order.dishDetails.length,
                itemBuilder: (context, index) {
                  final dish = order.dishDetails[index];
                  final currentStep = _getStepIndex(dish.status);

                  final Map<String, Color> stepColors = {};
                  for (int i = 0; i < _statusOrder.length; i++) {
                    stepColors[_statusOrder[i]] = (i <= currentStep)
                        ? Theme.of(context).primaryColor
                        : Colors.grey;
                  }

                  return OrderCard(
                    dishName: dish.name,
                    qty: dish.quantity,
                    price: dish.price,
                    status: dish.status,
                    autoFocus: index == 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
