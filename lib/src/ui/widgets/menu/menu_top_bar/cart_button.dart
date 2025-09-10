import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../notifiers/cart_notifier.dart';

class CartButton extends ConsumerStatefulWidget {
  const CartButton({super.key});

  @override
  ConsumerState<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends ConsumerState<CartButton> {
  bool cartFocused = false;

  @override
  Widget build(BuildContext context) {
    final totalCount = ref
        .watch(itemQuantitiesProvider)
        .fold(0, (sum, dishWithQty) => sum + dishWithQty.quantity);

    return Focus(
      onFocusChange: (hasFocus) => setState(() => cartFocused = hasFocus),
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.select ||
            event.logicalKey == LogicalKeyboardKey.enter) {
          _goToCart();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: InkWell(
        onTap: _goToCart,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: cartFocused
                    ? Theme.of(context).primaryColor
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(26),
              ),
              child: SizedBox(
                height: 26,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'jio_ird/assets/images/ic_cart.svg',
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Go to Cart',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            if (totalCount > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _goToCart() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/cart',
      (route) => route.settings.name != '/cart',
    );
  }
}
