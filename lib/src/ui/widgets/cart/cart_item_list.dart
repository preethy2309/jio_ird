import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/dish_with_quantity.dart';
import '../../../notifiers/cart_notifier.dart';
import '../../../notifiers/meal_notifier.dart';
import '../../../providers/focus_provider.dart';
import '../menu/cooking_instruction_dialog.dart';
import 'cart_item_tile.dart';

class CartItemsList extends ConsumerStatefulWidget {
  const CartItemsList({super.key});

  @override
  ConsumerState<CartItemsList> createState() => _CartItemsListState();
}

class _CartItemsListState extends ConsumerState<CartItemsList> {
  final ScrollController _scrollController = ScrollController();

  late List<FocusNode> cartFocusNodes;
  late List<FocusNode> plusFocusNodes;
  late List<FocusNode> minusFocusNodes;
  late List<FocusNode> editFocusNodes;

  @override
  void initState() {
    super.initState();
    cartFocusNodes = [];
    plusFocusNodes = [];
    minusFocusNodes = [];
    editFocusNodes = [];
  }

  @override
  void dispose() {
    for (final node in cartFocusNodes) {
      node.dispose();
    }
    for (final node in plusFocusNodes) {
      node.dispose();
    }
    for (final node in minusFocusNodes) {
      node.dispose();
    }
    for (final node in editFocusNodes) {
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
    final items = ref.watch(itemQuantitiesProvider);

    while (cartFocusNodes.length < items.length) {
      cartFocusNodes.add(FocusNode());
    }
    while (plusFocusNodes.length < items.length) {
      plusFocusNodes.add(FocusNode());
    }
    while (minusFocusNodes.length < items.length) {
      minusFocusNodes.add(FocusNode());
    }
    while (editFocusNodes.length < items.length) {
      editFocusNodes.add(FocusNode());
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final dishWithQty = items[index];
        final dish = dishWithQty.dish;
        final quantity = dishWithQty.quantity;

        final cartNode = cartFocusNodes[index];
        final plusNode = plusFocusNodes[index];
        final minusNode = minusFocusNodes[index];
        final editNode = editFocusNodes[index];

        return Focus(
          focusNode: cartNode,
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              plusNode.requestFocus();
              _ensureVisible(cartNode);
            }
          },
          onKeyEvent: (node, event) {
            if (event is! KeyDownEvent) return KeyEventResult.ignored;
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              if (index == 0 && (plusNode.hasFocus || minusNode.hasFocus)) {
                ref.watch(cartTabFocusNodeProvider).requestFocus();
                return KeyEventResult.handled;
              }
            }

            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              if (plusNode.hasFocus || minusNode.hasFocus) {
                editNode.requestFocus();
                _ensureVisible(editNode);
                return KeyEventResult.handled;
              }
            }

            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              if (editNode.hasFocus) {
                plusNode.requestFocus();
                _ensureVisible(plusNode);
                return KeyEventResult.handled;
              }
            }

            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              if (plusNode.hasFocus) {
                ref.read(placeOrderFocusNodeProvider).requestFocus();
              } else {
                plusNode.requestFocus();
                _ensureVisible(plusNode);
              }
              return KeyEventResult.handled;
            }

            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              if (minusNode.hasFocus) {
                editNode.requestFocus();
                _ensureVisible(editNode);
              }
              if (editNode.hasFocus) {
                final placeOrderNode = ref.read(placeOrderFocusNodeProvider);
                placeOrderNode.requestFocus();
              } else if (plusNode.hasFocus) {
                minusNode.requestFocus();
                _ensureVisible(minusNode);
              }
              return KeyEventResult.handled;
            }

            if (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.select) {
              final idx = ref
                  .read(itemQuantitiesProvider)
                  .indexWhere((e) => e.dish.id == dish.id);
              if (editNode.hasFocus) {
                showCookingInstructionDialog(
                  context,
                  ref,
                  dishWithQty,
                  () {
                    editNode.requestFocus();
                    _ensureVisible(editNode);
                  },
                );
              } else if (plusNode.hasFocus ||
                  (!plusNode.hasFocus && !minusNode.hasFocus)) {
                ref.read(itemQuantitiesProvider.notifier).increment(idx);
                plusNode.requestFocus();
                _ensureVisible(plusNode);
              } else if (minusNode.hasFocus) {
                ref.read(itemQuantitiesProvider.notifier).decrement(idx);
                minusNode.requestFocus();
                _ensureVisible(minusNode);
              }
              return KeyEventResult.handled;
            }

            return KeyEventResult.ignored;
          },
          child: CartItemTile(
            title: dish.name,
            quantity: quantity,
            price: dish.dishPrice,
            type: dish.dishType,
            cookingInstructions: dishWithQty.cookingRequest ?? '',
            editFocusNode: editNode,
            onEditInstruction: () {
              showCookingInstructionDialog(
                context,
                ref,
                dishWithQty,
                () {
                  editNode.requestFocus();
                  _ensureVisible(editNode);
                },
              );
            },
            onIncrement: () {
              ref.read(itemQuantitiesProvider.notifier).increment(index);
              plusNode.requestFocus();
              _ensureVisible(plusNode);
            },
            onDecrement: () {
              ref.read(itemQuantitiesProvider.notifier).decrement(index);
              minusNode.requestFocus();
              _ensureVisible(minusNode);
            },
            plusFocusNode: plusNode,
            minusFocusNode: minusNode,
          ),
        );
      },
    );
  }
}

void showCookingInstructionDialog(
  BuildContext context,
  WidgetRef ref,
  DishWithQuantity dish,
  Function() onDialogClose,
) {
  showDialog(
    barrierColor: Colors.black87,
    context: context,
    builder: (context) {
      TextEditingController instructionController = TextEditingController();
      instructionController.text = dish!.cookingRequest ?? '';
      return CookingInstructionDialog(
        dishName: dish.dish.name,
        controller: instructionController,
        onSave: (text) {
          ref
              .read(itemQuantitiesProvider.notifier)
              .updateCookingInstruction(dish.dish.id, text);
          ref
              .read(mealsProvider.notifier)
              .updateDishCookingInstruction(dish.dish.id, text);
          Navigator.of(context).pop();
          onDialogClose.call();
        },
        onCancel: () {
          Navigator.of(context).pop();
          onDialogClose.call();
        },
      );
    },
  );
}
