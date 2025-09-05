import 'package:flutter/material.dart';

import '../quantity_selector.dart';

class CartItemTile extends StatelessWidget {
  final String title;
  final int quantity;
  final String price;
  final String type;
  final String cookingInstructions;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onEditInstruction;

  final FocusNode plusFocusNode;
  final FocusNode minusFocusNode;
  final FocusNode editFocusNode;

  const CartItemTile({
    super.key,
    required this.title,
    required this.quantity,
    required this.price,
    this.type = "veg",
    required this.onIncrement,
    required this.onDecrement,
    required this.onEditInstruction,
    required this.plusFocusNode,
    required this.minusFocusNode,
    this.cookingInstructions = "",
    required this.editFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final Color dotColor =
        type.toLowerCase() == "veg" ? Colors.green : Colors.red;

    final bool hasPrice = (double.tryParse(price) ?? 0) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasPrice
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: dotColor, width: 1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dotColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 60),
                        Text(
                          "₹$price",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    QuantitySelector(
                      quantity: quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                      plusButtonFocusNode: plusFocusNode,
                      minusButtonFocusNode: minusFocusNode,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: dotColor, width: 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    QuantitySelector(
                      quantity: quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                      plusButtonFocusNode: plusFocusNode,
                      minusButtonFocusNode: minusFocusNode,
                    ),
                  ],
                ),

          const SizedBox(height: 8),

          // Cooking instructions field
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  cookingInstructions.isEmpty
                      ? "Add cooking instruction"
                      : cookingInstructions,
                  style: TextStyle(
                    fontSize: 13,
                    color: cookingInstructions.isEmpty
                        ? Colors.grey.shade500
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Focus(
                focusNode: editFocusNode,
                child: Builder(builder: (context) {
                  final hasFocus = Focus.of(context).hasFocus;
                  return InkWell(
                    onTap: onEditInstruction,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        cookingInstructions.isEmpty ? "Add" : "Edit",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  );
                }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
