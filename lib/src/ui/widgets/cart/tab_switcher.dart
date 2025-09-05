import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/focus_provider.dart';
import '../../../providers/state_provider.dart';

class TabSwitcher extends ConsumerStatefulWidget {
  const TabSwitcher({super.key});

  @override
  ConsumerState<TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends ConsumerState<TabSwitcher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartFocusNode = ref.read(cartTabFocusNodeProvider);
      cartFocusNode.requestFocus();
      ref.read(selectedCartTabProvider.notifier).state = CartTab.cart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(selectedCartTabProvider);
    final itemsTabFocusNode = ref.watch(cartTabFocusNodeProvider);
    final infoTabFocusNode = ref.watch(myOrdersTabFocusNodeProvider);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border.all(color: Colors.grey.shade800, width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            label: "Cart",
            isSelected: selectedTab == CartTab.cart,
            focusNode: itemsTabFocusNode,
            onSelect: () {
              ref.read(selectedCartTabProvider.notifier).state = CartTab.cart;
              itemsTabFocusNode.requestFocus();
            },
            onRight: () {
              infoTabFocusNode.requestFocus();
              ref.read(selectedCartTabProvider.notifier).state = CartTab.orders;
            },
            onLeft: null,
          ),
          const SizedBox(width: 4),
          _buildTab(
            label: "My Orders",
            isSelected: selectedTab == CartTab.orders,
            focusNode: infoTabFocusNode,
            onSelect: () {
              ref.read(orderPlacedProvider.notifier).state = false;
              ref.read(selectedCartTabProvider.notifier).state = CartTab.orders;
              infoTabFocusNode.requestFocus();
            },
            onRight: null,
            onLeft: () {
              itemsTabFocusNode.requestFocus();
              ref.read(selectedCartTabProvider.notifier).state = CartTab.cart;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required FocusNode focusNode,
    required VoidCallback onSelect,
    VoidCallback? onLeft,
    VoidCallback? onRight,
  }) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (hasFocus) {
        if (hasFocus) onSelect();
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              onRight != null) {
            onRight();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              onLeft != null) {
            onLeft();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            return KeyEventResult.handled;
          }

          if (label != "Cart" &&
              (event.logicalKey == LogicalKeyboardKey.arrowRight)) {
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;

          return AnimatedContainer(
            width: 120,
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: hasFocus
                  ? Theme.of(context).colorScheme.onPrimary
                  : (isSelected ? Colors.white70 : Colors.transparent),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: (isSelected || hasFocus)
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
