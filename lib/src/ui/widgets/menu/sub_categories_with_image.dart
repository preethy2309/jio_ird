import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/food_item.dart';
import '../../../providers/focus_provider.dart';
import '../../../providers/state_provider.dart';
import '../../../utils/helper.dart';
import '../dish_image.dart';

class SubCategoriesWithImage extends ConsumerStatefulWidget {
  final List<FoodItem> subCategories;

  const SubCategoriesWithImage({super.key, required this.subCategories});

  @override
  ConsumerState<SubCategoriesWithImage> createState() =>
      _SubCategoriesWithImageState();
}

class _SubCategoriesWithImageState
    extends ConsumerState<SubCategoriesWithImage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final noDishes = ref.watch(noDishesProvider);
    final showCategories = ref.watch(showCategoriesProvider);
    final focusedIndex = ref.watch(focusedSubCategoryProvider);
    return ListView.builder(
      controller: _scrollController as ScrollController?,
      itemCount: widget.subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = widget.subCategories[index];
        final isFocused = index == focusedIndex;

        final focusNode = ref.watch(subCategoryMainFocusNodeProvider(index));

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && isFocused) {
              if (hasSubCategories(ref)) {
                ref.read(showSubCategoriesProvider.notifier).state = true;
              } else {
                ref.read(showCategoriesProvider.notifier).state = true;
              }
            }
          },
          child: Focus(
            skipTraversal: showCategories,
            canRequestFocus: !showCategories,
            focusNode: focusNode,
            onFocusChange: (hasFocus) {
              ref.read(focusedSubCategoryProvider.notifier).state = index;
              if (hasFocus) {
                ref.read(focusedDishProvider.notifier).state = -1;
                ref.read(selectedDishProvider.notifier).state = -1;
              }
            },
            onKeyEvent: (node, event) {
              if (event is! KeyDownEvent) return KeyEventResult.ignored;

              if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                ref.read(showCategoriesProvider.notifier).state = true;
                ref.read(selectedSubCategoryProvider.notifier).state = -1;
              }

              if ((event.logicalKey == LogicalKeyboardKey.arrowRight ||
                  event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.select)) {
                if (!noDishes) {
                  ref.read(selectedSubCategoryProvider.notifier).state = index;
                  ref.read(showSubCategoriesProvider.notifier).state = false;
                  ref.read(focusedDishProvider.notifier).state = -1;
                  ref.read(selectedDishProvider.notifier).state = 0;
                  return KeyEventResult.handled;
                }
              }
              return KeyEventResult.ignored;
            },
            child: Container(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
