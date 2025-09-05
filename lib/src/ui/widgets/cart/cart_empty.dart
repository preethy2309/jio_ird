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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: _isFocused
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () => {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/menu',
                    (route) => false, // removes everything from stack
                  )
                },
                child:  Text(
                  "Go To Menu",
                  style: TextStyle(
                      color: _isFocused
                          ? Theme.of(context).colorScheme.onPrimary
                          : Colors.black,
                      fontSize: 16, fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
