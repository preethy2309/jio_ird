import 'package:flutter/material.dart';
import 'package:jio_ird/src/ui/widgets/my_orders/status_connector.dart';
import 'package:jio_ird/src/ui/widgets/my_orders/status_step.dart';

class OrderCard extends StatefulWidget {
  final String dishName;
  final int qty;
  final String price;
  final String status;
  final bool autoFocus;

  const OrderCard({
    super.key,
    required this.dishName,
    required this.qty,
    required this.price,
    required this.status,
    required this.autoFocus,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isFocused = false;

  int _statusToIndex(String status) {
    switch (status.toLowerCase()) {
      case "placed":
        return 0;
      case "accepted":
        return 1;
      case "preparing":
        return 2;
      case "served":
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _statusToIndex(widget.status);

    return Focus(
      autofocus: widget.autoFocus,
      onFocusChange: (focused) {
        setState(() {
          isFocused = focused;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isFocused ? Colors.white70 : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Dish info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.dishName,
                        style: TextStyle(
                          color: isFocused ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Qty. ${widget.qty}   ₹ ${widget.price}",
                    style: TextStyle(
                      color: isFocused ? Colors.black : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Status steps
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF111111),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusStep(
                    icon: Icons.room_service,
                    label: "Order Placed",
                    active: currentStep >= 0,
                  ),
                  StatusConnector(active: currentStep >= 1),
                  StatusStep(
                    icon: Icons.check_circle_outline,
                    label: "Accepted",
                    active: currentStep >= 1,
                  ),
                  StatusConnector(active: currentStep >= 2),
                  StatusStep(
                    icon: Icons.restaurant_menu,
                    label: "Preparing",
                    active: currentStep >= 2,
                  ),
                  StatusConnector(active: currentStep >= 3),
                  StatusStep(
                    icon: Icons.delivery_dining,
                    label: "Served",
                    active: currentStep >= 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
