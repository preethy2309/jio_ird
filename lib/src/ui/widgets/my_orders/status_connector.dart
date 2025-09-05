import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class StatusConnector extends StatelessWidget {
  final bool active;

  const StatusConnector({required this.active, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: DottedLine(
        direction: Axis.horizontal,
        dashLength: 4,
        dashGapLength: 3,
        dashColor: active
            ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
            : Colors.white38,
      ),
    );
  }
}
