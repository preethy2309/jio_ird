import 'package:flutter/material.dart';

class BottomLayout extends StatelessWidget {
  const BottomLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Select',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 60),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.keyboard_arrow_up,
                    size: 18, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 8),
              Text(
                'Navigate',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 60),
          Row(
            children: [
              Container(
                width: 25,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF3CA210),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Clear App',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
