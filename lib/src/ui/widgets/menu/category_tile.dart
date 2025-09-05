import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTile extends ConsumerWidget {
  final String title;
  final int index;
  final bool isSelected;
  final bool isFocused;
  final bool isLastIndex;
  final FocusNode focusNode;
  final VoidCallback onSelect;
  final ValueChanged<bool> onFocusChange;
  final VoidCallback onLeft;

  const CategoryTile({
    super.key,
    required this.title,
    required this.index,
    required this.isSelected,
    required this.isFocused,
    required this.isLastIndex,
    required this.focusNode,
    required this.onSelect,
    required this.onFocusChange,
    required this.onLeft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (hasFocus) {
        onFocusChange(hasFocus);
      },
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if ((event.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.select)) {
          onSelect();
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowDown && isLastIndex) {
          return KeyEventResult.handled;
        }

        if ((event.logicalKey == LogicalKeyboardKey.arrowLeft)) {
          onLeft();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: 36,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isFocused
              ? Theme.of(context).colorScheme.primary
              : isSelected
                  ? Colors.white70
                  : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isFocused || isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
