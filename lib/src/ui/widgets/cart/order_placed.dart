import 'package:flutter/material.dart';

class OrderPlaced extends StatefulWidget {
  final VoidCallback onTrackOrder;

  const OrderPlaced({super.key, required this.onTrackOrder});

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  late FocusNode _trackOrderButtonFocusNode;

  @override
  void initState() {
    super.initState();
    _trackOrderButtonFocusNode = FocusNode();

    // Request focus after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackOrderButtonFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _trackOrderButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.check, size: 30, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text(
            "Order Placed !",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your order was placed successfully",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            focusNode: _trackOrderButtonFocusNode,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.focused)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return Colors.white;
              }),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 24),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            onPressed: widget.onTrackOrder,
            child: Text(
              "Track order",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
