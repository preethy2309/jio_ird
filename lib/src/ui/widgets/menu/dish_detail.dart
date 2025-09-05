import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/ui/widgets/dish_image.dart';

import '../../../data/models/dish_model.dart';
import '../../../notifiers/cart_notifier.dart';
import '../../../notifiers/meal_notifier.dart';
import '../../../providers/focus_provider.dart';
import '../../../providers/state_provider.dart';
import '../../../utils/helper.dart';
import '../veg_indicator.dart';
import 'cooking_instruction_dialog.dart';

class DishDetail extends ConsumerWidget {
  final Dish? dish;
  final String categoryName;
  final int itemCount;

  const DishDetail({
    super.key,
    required this.dish,
    required this.categoryName,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dish == null) {
      return const Center(child: Text("No dish available"));
    }

    final cartItems = ref.watch(itemQuantitiesProvider);
    final isInCart = cartItems.any((item) => item.dish.id == dish!.id);
    final focusedDish = ref.watch(focusedDishProvider);
    final isCategory = focusedDish == -1 ||
        (hasSubCategories(ref) && ref.read(showSubCategoriesProvider)) ||
        ref.read(showCategoriesProvider);
    final bool hasPrice = (double.tryParse(dish!.dishPrice) ?? 0) > 0;

    if (isCategory) {
      return Container(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DishImage(
              imageUrl: dish?.dishImage,
              width: double.infinity,
              height: 220,
              borderRadius: 16,
              fallbackWidth: 120,
              fallbackHeight: 120,
            ),
            const SizedBox(height: 8),
            Text(
              itemCount > 7 ? "7+" : "$itemCount",
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DishImage(
            imageUrl: dish?.dishImage,
            width: double.infinity,
            height: 220,
            borderRadius: 16,
            fallbackWidth: 120,
            fallbackHeight: 120,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VegIndicator(
                  size: 6,
                  color: (dish!.dishType.toLowerCase() == 'veg'
                      ? Colors.green
                      : Colors.red)),
              const SizedBox(width: 4),
              Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          if (hasPrice)
            Text(
              '₹${dish!.dishPrice}',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          Text(
            dish!.name,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            dish!.description,
            maxLines: 2,
            style: const TextStyle(color: Colors.white70, height: 1.0),
          ),
          if (isInCart) ...[
            if (dish!.cookingRequest?.isNotEmpty == true)
              Text(
                'Cooking instruction : ${dish!.cookingRequest}',
                maxLines: 1,
                style: const TextStyle(color: Colors.white54),
              ),
            const SizedBox(height: 4),
            Center(
              child: SizedBox(
                height: 35,
                child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is! KeyDownEvent) return KeyEventResult.ignored;
                    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                      if (ref.read(showCategoriesProvider)) {
                        final lastFocusedCategory =
                            ref.read(selectedCategoryProvider);
                        final categoryIndex = (lastFocusedCategory >= 0)
                            ? lastFocusedCategory
                            : 0;

                        ref
                            .read(categoryFocusNodeProvider(categoryIndex))
                            .requestFocus();
                      } else if (hasSubCategories(ref) &&
                          ref.read(showSubCategoriesProvider)) {
                        final lastFocusedCategory =
                            ref.read(selectedSubCategoryProvider);
                        final categoryIndex = (lastFocusedCategory >= 0)
                            ? lastFocusedCategory
                            : 0;

                        ref
                            .read(subCategoryFocusNodeProvider(categoryIndex))
                            .requestFocus();
                      } else {
                        final lastFocusedDish = ref.read(focusedDishProvider);
                        int index = 0;
                        if (lastFocusedDish >= 0) {
                          index = lastFocusedDish;
                        }
                        ref.read(dishFocusNodeProvider(index)).requestFocus();
                      }
                      return KeyEventResult.handled;
                    }

                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: ElevatedButton(
                    focusNode: ref.watch(cookingInstructionFocusNodeProvider),
                    onPressed: () {
                      showDialog(
                        barrierColor: Colors.black87,
                        context: context,
                        builder: (context) {
                          TextEditingController instructionController =
                              TextEditingController();
                          instructionController.text =
                              dish!.cookingRequest ?? '';
                          return CookingInstructionDialog(
                            dishName: dish!.name,
                            controller: instructionController,
                            onSave: (text) {
                              ref
                                  .read(itemQuantitiesProvider.notifier)
                                  .updateCookingInstruction(dish!.id, text);
                              ref
                                  .read(mealsProvider.notifier)
                                  .updateDishCookingInstruction(dish!.id, text);
                              Navigator.of(context).pop();
                            },
                            onCancel: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(WidgetState.focused)) {
                            return Theme.of(context).colorScheme.primary;
                          }
                          return Colors.white70;
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(WidgetState.focused)) {
                            return Theme.of(context).colorScheme.onPrimary;
                          }
                          return Colors.black;
                        },
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      (dish!.cookingRequest == null ||
                              dish!.cookingRequest!.isEmpty)
                          ? "Add Cooking Instructions"
                          : "Edit Cooking Instructions",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
