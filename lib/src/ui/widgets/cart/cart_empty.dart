import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmptyCartScreen extends StatefulWidget {
  final String title;

  const EmptyCartScreen({
    super.key,
    required this.title,
  });

  @override
  State<EmptyCartScreen> createState() => _EmptyCartScreenState();
}

class _EmptyCartScreenState extends State<EmptyCartScreen> {
  final FocusNode _buttonFocusNode = FocusNode();
  bool _isFocused = false;

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image
          Image.asset(
            "jio_ird/assets/images/cart_empty.png",
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          const Text(
            "Looks like you haven’t made your choice yet..",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Focusable Button
          Focus(
            focusNode: _buttonFocusNode,
            onFocusChange: (hasFocus) {
              setState(() => _isFocused = hasFocus);
            },
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.select)) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/menu',
                  (route) => false,
                );
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/menu',
                  (route) => false,
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.focused)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Theme.of(context).colorScheme.secondary;
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
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              child: const Text(
                "Go To Menu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
