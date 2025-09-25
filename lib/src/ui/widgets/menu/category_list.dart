import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/food_item.dart';
import '../../../providers/focus_provider.dart';
import '../../../providers/state_provider.dart';
import '../../../utils/helper.dart';
import 'category_tile.dart';

class CategoryList extends ConsumerStatefulWidget {
  final List<FoodItem> categories;

  const CategoryList({super.key, required this.categories});

  @override
  ConsumerState<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends ConsumerState<CategoryList> {
  int focusedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final noDishes = ref.watch(noDishesProvider);

    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() => focusedIndex = -1);
        }
      },
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (focusedIndex > 0) {
            final prevNode = ref.read(categoryFocusNodeProvider(focusedIndex - 1));
            Future.microtask(() => prevNode.requestFocus());
            return KeyEventResult.handled;
          }
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          if (focusedIndex < widget.categories.length - 1) {
            final nextNode = ref.read(categoryFocusNodeProvider(focusedIndex + 1));
            Future.microtask(() => nextNode.requestFocus());
          }
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: ListView.builder(
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedCategory;
          final isFocused = index == focusedIndex;

          final focusNode = ref.watch(categoryFocusNodeProvider(index));

          return CategoryTile(
            title: widget.categories[index].categoryName ?? '',
            index: index,
            isSelected: isSelected,
            isFocused: isFocused,
            focusNode: focusNode,
            isLastIndex: index == widget.categories.length - 1,
            onSelect: () {
              if (!noDishes) {
                ref.read(selectedCategoryProvider.notifier).state = index;
                ref.read(showCategoriesProvider.notifier).state = false;
                if (hasSubCategories(ref)) {
                  ref.read(selectedSubCategoryProvider.notifier).state = -1;
                  ref.read(focusedSubCategoryProvider.notifier).state = 0;
                  ref.read(focusedDishProvider.notifier).state = -1;
                  ref.read(selectedDishProvider.notifier).state = -1;
                } else {
                  ref.read(selectedDishProvider.notifier).state = -1;
                  ref.read(focusedDishProvider.notifier).state = 0;
                }
              }
            },
            onFocusChange: (hasFocus) {
              ref.read(isCategoryFocusedProvider.notifier).state = isFocused;
              setState(() {
                focusedIndex = hasFocus ? index : focusedIndex;
              });
              if (hasFocus) {
                ref.read(isSubCategoryListFocusedProvider.notifier).state = false;
                ref.read(selectedCategoryProvider.notifier).state = index;
                ref.read(focusedSubCategoryProvider.notifier).state = -1;
                ref.read(selectedSubCategoryProvider.notifier).state = -1;
                ref.read(selectedDishProvider.notifier).state = -1;
                ref.read(focusedDishProvider.notifier).state = -1;
              }
            },
            onLeft: () {},
          );
        },
      ),
    );
  }
}
