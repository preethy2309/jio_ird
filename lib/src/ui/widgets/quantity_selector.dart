import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final FocusNode plusButtonFocusNode;
  final FocusNode minusButtonFocusNode;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.plusButtonFocusNode,
    required this.minusButtonFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 38,
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              Colors.white.withOpacity(0.5),
              Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(38),
          ),
        ),
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedQtyButton(
                icon: Icons.add,
                onTap: onIncrement,
                focusNode: plusButtonFocusNode,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 20, // fixed width
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(
                      quantity.toString().padLeft(2, ' '),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              _AnimatedQtyButton(
                icon: Icons.remove,
                onTap: onDecrement,
                focusNode: minusButtonFocusNode,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedQtyButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final FocusNode focusNode;

  const _AnimatedQtyButton({
    required this.icon,
    required this.onTap,
    required this.focusNode,
  });

  @override
  State<_AnimatedQtyButton> createState() => _AnimatedQtyButtonState();
}

class _AnimatedQtyButtonState extends State<_AnimatedQtyButton> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      child: InkWell(
        onTap: widget.onTap,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _isFocused ? 36 : 28,
          height: _isFocused ? 36 : 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isFocused ? Theme.of(context).primaryColor : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color: _isFocused
                ? Theme.of(context).colorScheme.secondary
                : Colors.black,
            size: _isFocused ? 26 : 18,
          ),
        ),
      ),
    );
  }
}
