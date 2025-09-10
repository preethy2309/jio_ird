import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/data/models/food_item.dart';

import '../dish_image.dart';

class SubCategoryTile extends ConsumerWidget {
  final FoodItem subCategory;
  final int index;
  final bool isSelected;
  final bool isFocused;
  final bool isLastIndex;
  final FocusNode focusNode;
  final VoidCallback onSelect;
  final ValueChanged<bool> onFocusChange;
  final VoidCallback onLeft;

  const SubCategoryTile({
    super.key,
    required this.subCategory,
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
      child:
      Container(
        height: 76,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isFocused
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            DishImage(
              imageUrl: subCategory.dishes?.isNotEmpty == true
                  ? subCategory.dishes![0].dishImage
                  : null,
              width: 75,
              height: 75,
              borderRadius: 6,
              fallbackWidth: 45,
              fallbackHeight: 45,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                subCategory.categoryName ?? '',
                style: TextStyle(
                  color: isFocused
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isFocused
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
