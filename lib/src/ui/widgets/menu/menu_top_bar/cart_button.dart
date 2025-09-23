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
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: InkWell(
        onTap: _goToCart,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: cartFocused
                    ? Theme.of(context).primaryColor
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(26),
                boxShadow: cartFocused
                    ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme.secondary
                        .withValues(alpha: 0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
                    : [],
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
                      colorFilter: ColorFilter.mode(
                        cartFocused
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedDefaultTextStyle(
                      style: TextStyle(
                        color: cartFocused
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white,
                        fontWeight:
                        cartFocused ? FontWeight.bold : FontWeight.normal,
                      ),
                      duration: const Duration(milliseconds: 150),
                      child: const Text('Go to Cart'),
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
