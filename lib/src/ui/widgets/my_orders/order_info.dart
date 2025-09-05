import 'package:flutter/material.dart';

class OrderInfo extends StatelessWidget {
  final String orderNo;

  final String billDetails;

  final String toPay;

  final bool isActive;

  const OrderInfo({
    super.key,
    required this.orderNo,
    required this.billDetails,
    required this.toPay,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order No",
              style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                      : Colors.grey,
                  fontSize: 14),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 4),
            Text(
              orderNo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        // Divider
        const SizedBox(width: 24),
        Container(
          width: 1,
          height: 40,
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : Colors.grey.shade400,
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bill details",
              style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                      : Colors.grey,
                  fontSize: 14),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 4),
            Text(
              billDetails,
              style: TextStyle(
                  fontSize: 16,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        const SizedBox(width: 24),
        Container(
          width: 1,
          height: 40,
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : Colors.grey.shade400,
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To Pay",
              style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                      : Colors.grey,
                  fontSize: 14),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 4),
            Text(
              toPay,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ],
    );
  }
}
