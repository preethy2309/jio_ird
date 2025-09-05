import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/dish_with_quantity.dart';
import '../../../notifiers/cart_notifier.dart';
import '../../../providers/focus_provider.dart';
import '../../../providers/state_provider.dart';
import '../../../utils/helper.dart';
import '../dish_image.dart';
import '../quantity_selector.dart';

class DishList extends ConsumerStatefulWidget {
  final List<dynamic> dishes;

  const DishList({super.key, required this.dishes});

  @override
  ConsumerState<DishList> createState() => _DishListState();
}

class _DishListState extends ConsumerState<DishList> {
  final ScrollController _scrollController = ScrollController();

  late List<FocusNode> plusFocusNodes;
  late List<FocusNode> minusFocusNodes;

  @override
  void initState() {
    super.initState();

    plusFocusNodes = List.generate(widget.dishes.length, (_) => FocusNode());
    minusFocusNodes = List.generate(widget.dishes.length, (_) => FocusNode());
  }

  @override
  void didUpdateWidget(DishList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dishes.length != widget.dishes.length) {
      for (final node in plusFocusNodes) {
        node.dispose();
      }
      plusFocusNodes = List.generate(widget.dishes.length, (_) => FocusNode());

      for (final node in minusFocusNodes) {
        node.dispose();
      }
      minusFocusNodes = List.generate(widget.dishes.length, (_) => FocusNode());
    }
  }

  @override
  void dispose() {
    for (final node in plusFocusNodes) {
      node.dispose();
    }
    for (final node in minusFocusNodes) {
      node.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _ensureVisible(FocusNode node) async {
    if (node.context != null) {
      await Scrollable.ensureVisible(
        node.context!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDish = ref.watch(selectedDishProvider);
    final focusedDish = ref.watch(focusedDishProvider);
    final itemQuantities = ref.watch(itemQuantitiesProvider);
    final showCategories = ref.watch(showCategoriesProvider);
    final showSubCategories =
        hasSubCategories(ref) && ref.watch(showSubCategoriesProvider);

    return ListView.builder(
      controller: _scrollController as ScrollController?,
      itemCount: widget.dishes.length,
      itemBuilder: (context, index) {
        final dish = widget.dishes[index];
        final isSelected = index == selectedDish;
        final isFocused = index == focusedDish;
        final quantity = ref.watch(itemQuantitiesProvider.select((cart) => cart
            .firstWhere(
              (item) => item.dish.id == dish.id,
              orElse: () => DishWithQuantity(dish: dish, quantity: 0),
            )
            .quantity));

        final dishNode = ref.watch(dishFocusNodeProvider(index));
        final plusNode = plusFocusNodes[index];
        final minusNode = minusFocusNodes[index];

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && isFocused) {
              if (hasSubCategories(ref)) {
                ref.read(showSubCategoriesProvider.notifier).state = true;
                ref.read(focusedDishProvider.notifier).state = -1;
              } else {
                ref.read(showCategoriesProvider.notifier).state = true;
              }
            }
          },
          child: Focus(
            focusNode: dishNode,
            skipTraversal: (showCategories || showSubCategories) || isSelected,
            canRequestFocus:
                (!showCategories || !showSubCategories) && !isSelected,
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                ref.read(focusedDishProvider.notifier).state = index;
                _ensureVisible(dishNode);
                if (selectedDish != focusedDish) {
                  ref.read(selectedDishProvider.notifier).state = -1;
                }
                if (quantity != 0) {
                  plusNode.requestFocus();
                }
              }
            },
            onKeyEvent: (node, event) {
              if (event is! KeyDownEvent) return KeyEventResult.ignored;

              if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                if (isFocused) {
                  if (minusNode.hasFocus) {
                    Future.microtask(() {
                      plusNode.requestFocus();
                      _ensureVisible(plusNode);
                    });
                    return KeyEventResult.handled;
                  } else {
                    if (hasSubCategories(ref)) {
                      ref.read(showSubCategoriesProvider.notifier).state = true;
                      ref.read(focusedDishProvider.notifier).state = -1;
                    } else {
                      ref.read(showCategoriesProvider.notifier).state = true;
                    }
                  }
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                if (isFocused) {
                  if (minusNode.hasFocus || quantity == 0) {
                    ref
                        .read(cookingInstructionFocusNodeProvider)
                        .requestFocus();
                    return KeyEventResult.handled;
                  } else {
                    Future.microtask(() {
                      minusNode.requestFocus();
                      _ensureVisible(minusNode);
                    });
                  }
                  return KeyEventResult.handled;
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.select) {
                final idx =
                    itemQuantities.indexWhere((e) => e.dish.id == dish.id);
                final currentQty = idx >= 0 ? itemQuantities[idx].quantity : 0;

                if (currentQty == 0) {
                  ref
                      .read(itemQuantitiesProvider.notifier)
                      .addItem(DishWithQuantity(dish: dish, quantity: 1));
                  Future.microtask(() {
                    plusNode.requestFocus();
                    _ensureVisible(plusNode);
                  });
                } else {
                  Future.microtask(() {
                    if (plusNode.hasFocus ||
                        (!plusNode.hasFocus && !minusNode.hasFocus)) {
                      ref.read(itemQuantitiesProvider.notifier).increment(idx);
                      plusNode.requestFocus();
                      _ensureVisible(plusNode);
                    } else if (minusNode.hasFocus) {
                      ref.read(itemQuantitiesProvider.notifier).decrement(idx);
                      minusNode.requestFocus();
                      _ensureVisible(minusNode);
                    }
                  });
                }
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            child: InkWell(
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
                      imageUrl: dish.dishImage,
                      width: 75,
                      height: 75,
                      borderRadius: 6,
                      fallbackWidth: 45,
                      fallbackHeight: 45,
                    ),
                    const SizedBox(width: 10),
                    if (isFocused) ...[
                      if (quantity == 0)
                        ElevatedButton(
                          onPressed: () {
                            ref.read(itemQuantitiesProvider.notifier).addItem(
                                  DishWithQuantity(dish: dish, quantity: 1),
                                );
                            Future.microtask(() {
                              plusNode.requestFocus();
                              _ensureVisible(plusNode);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white70,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          child: const Text("Add to Cart"),
                        )
                      else
                        Builder(
                          builder: (context) {
                            Future.microtask(() {
                              if (!plusNode.hasFocus &&
                                  !minusNode.hasFocus &&
                                  isFocused) {
                                plusNode.requestFocus();
                                _ensureVisible(plusNode);
                              }
                            });

                            return QuantitySelector(
                              quantity: quantity,
                              onIncrement: () {
                                final idx = itemQuantities
                                    .indexWhere((e) => e.dish.id == dish.id);
                                if (idx >= 0) {
                                  ref
                                      .read(itemQuantitiesProvider.notifier)
                                      .increment(idx);
                                  Future.microtask(() {
                                    plusNode.requestFocus();
                                    _ensureVisible(plusNode);
                                  });
                                }
                              },
                              onDecrement: () {
                                final idx = itemQuantities
                                    .indexWhere((e) => e.dish.id == dish.id);
                                if (idx >= 0) {
                                  ref
                                      .read(itemQuantitiesProvider.notifier)
                                      .decrement(idx);
                                  Future.microtask(() {
                                    minusNode.requestFocus();
                                    _ensureVisible(minusNode);
                                  });
                                }
                              },
                              plusButtonFocusNode: plusNode,
                              minusButtonFocusNode: minusNode,
                            );
                          },
                        ),
                    ] else
                      Expanded(
                        child: Text(
                          dish.name,
                          style: const TextStyle(
                            color: Colors.white,
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
          ),
        );
      },
    );
  }
}
