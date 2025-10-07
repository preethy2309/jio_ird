import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/focus_provider.dart';
import '../../../../providers/state_provider.dart';
import '../../../../utils/helper.dart';
import '../../veg_indicator.dart';

class VegToggle extends ConsumerStatefulWidget {
  const VegToggle({super.key});

  @override
  ConsumerState<VegToggle> createState() => _VegToggleState();
}

class _VegToggleState extends ConsumerState<VegToggle> {
  bool toggleFocused = false;

  @override
  Widget build(BuildContext context) {
    final vegOnly = ref.watch(vegOnlyProvider);
    final focusNode = ref.watch(vegToggleFocusNodeProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final showCategories = ref.watch(showCategoriesProvider);
    final showSubCategories = ref.watch(showSubCategoriesProvider);

    return Focus(
      focusNode: focusNode,
      onFocusChange: (hasFocus) {
        setState(() => toggleFocused = hasFocus);
        if (hasFocus) {
          ref.read(resetFocusProvider);
          ref.read(focusedDishProvider.notifier).state = -2;
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;

          if (key == LogicalKeyboardKey.select ||
              key == LogicalKeyboardKey.enter) {
            ref.read(vegOnlyProvider.notifier).state = !vegOnly;
            return KeyEventResult.handled;
          }

          if (key == LogicalKeyboardKey.arrowLeft ||
              key == LogicalKeyboardKey.arrowDown) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (showCategories) {
                var index = selectedCategory == -1 ? 0 : selectedCategory;
                ref.read(categoryFocusNodeProvider(index)).requestFocus();
              } else if (hasSubCategories(ref) && showSubCategories) {
                var index = ref.watch(focusedSubCategoryProvider);
                ref
                    .read(subCategoryFocusNodeProvider(index == -1 ? 0 : index))
                    .requestFocus();
              } else {
                var index = ref.watch(focusedDishProvider);
                ref
                    .read(dishFocusNodeProvider(index == -1 ? 0 : index))
                    .requestFocus();
              }
            });
          }

          if (key == LogicalKeyboardKey.arrowRight) {
            ref.read(goToCartFocusNodeProvider).requestFocus();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: InkWell(
        onTap: () => ref.read(vegOnlyProvider.notifier).state = !vegOnly,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: toggleFocused
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: SizedBox(
            height: 26,
            child: Row(
              children: [
                const VegIndicator(),
                const SizedBox(width: 10),
                Text(
                  'Veg Only',
                  style: TextStyle(
                    color: toggleFocused
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 46,
                  height: 26,
                  child: Switch(
                    activeThumbColor: !toggleFocused
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary,
                    activeTrackColor: toggleFocused
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary,
                    inactiveTrackColor: !toggleFocused
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary,
                    inactiveThumbColor: toggleFocused
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary,
                    autofocus: true,
                    value: vegOnly,
                    onChanged: (value) =>
                        ref.read(vegOnlyProvider.notifier).state = value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
