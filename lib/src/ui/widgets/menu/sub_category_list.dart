import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/ui/widgets/menu/sub_category_tile.dart';

import '../../../data/models/food_item.dart';
import '../../../providers/focus_provider.dart';
import '../../../providers/state_provider.dart';

class SubCategoryList extends ConsumerStatefulWidget {
  final List<FoodItem> subCategories;

  const SubCategoryList({super.key, required this.subCategories});

  @override
  ConsumerState<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends ConsumerState<SubCategoryList> {
  int focusedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final selectedSub = ref.watch(selectedSubCategoryProvider);
    final noDishes = ref.watch(noDishesProvider);
    final showCategories = ref.watch(showCategoriesProvider);

    return Focus(
      skipTraversal: showCategories,
      canRequestFocus: !showCategories,
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() => focusedIndex = -1);
          ref.read(focusedSubCategoryProvider.notifier).state = -1;
        }
      },
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;

        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (focusedIndex > 0) {
            final prevNode =
                ref.read(subCategoryFocusNodeProvider(focusedIndex - 1));
            Future.microtask(() => prevNode.requestFocus());
            return KeyEventResult.handled;
          } else if (focusedIndex == 0) {
            final vegToggleNode = ref.read(vegToggleFocusNodeProvider);
            Future.microtask(() => vegToggleNode.requestFocus());
            return KeyEventResult.handled;
          }
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          if (focusedIndex < widget.subCategories.length - 1) {
            final nextNode =
                ref.read(subCategoryFocusNodeProvider(focusedIndex + 1));
            Future.microtask(() => nextNode.requestFocus());
            return KeyEventResult.handled;
          } else if (focusedIndex == widget.subCategories.length - 1) {
            return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },
      child: ListView.builder(
        itemCount: widget.subCategories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedSub;
          final isFocused = index == focusedIndex;

          final focusNode = ref.watch(subCategoryFocusNodeProvider(index));
          return SubCategoryTile(
            subCategory: widget.subCategories[index],
            index: index,
            isSelected: isSelected,
            isFocused: isFocused,
            focusNode: focusNode,
            isLastIndex: index == widget.subCategories.length - 1,
            onSelect: () {
              if (!noDishes) {
                ref.read(selectedSubCategoryProvider.notifier).state = index;
                ref.read(showSubCategoriesProvider.notifier).state = false;
                ref.read(focusedDishProvider.notifier).state = -1;
                ref.read(selectedDishProvider.notifier).state = -1;
              }
            },
            onFocusChange: (hasFocus) {
              ref.read(isSubCategoryListFocusedProvider.notifier).state =
                  hasFocus;
              ref.read(isDishFocusedProvider.notifier).state = false;

              setState(() {
                focusedIndex = hasFocus ? index : focusedIndex;
              });

              if (hasFocus) {
                ref.read(focusedSubCategoryProvider.notifier).state = index;
                ref.read(selectedSubCategoryProvider.notifier).state = index;
                ref.read(selectedDishProvider.notifier).state = -1;
                ref.read(focusedDishProvider.notifier).state = -1;
              }
            },
            onLeft: () {
              ref.read(showCategoriesProvider.notifier).state = true;
              ref.read(selectedSubCategoryProvider.notifier).state = -1;
              ref.read(isCategoryFocusedProvider.notifier).state = true;
            },
          );
        },
      ),
    );
  }
}
