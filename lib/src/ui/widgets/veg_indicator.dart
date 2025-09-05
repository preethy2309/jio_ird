import 'package:flutter/material.dart';

class VegIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final double borderWidth;

  const VegIndicator({
    super.key,
    this.color = Colors.green,
    this.size = 10,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: color, width: borderWidth),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
