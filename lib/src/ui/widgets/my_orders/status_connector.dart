import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class StatusConnector extends StatelessWidget {
  final bool active;
  final double? width;

  const StatusConnector({required this.active, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 120,
      child: DottedLine(
        direction: Axis.horizontal,
        dashLength: 4,
        dashGapLength: 3,
        dashColor: active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
