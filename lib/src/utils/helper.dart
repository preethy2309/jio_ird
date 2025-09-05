import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/meal_notifier.dart';
import '../providers/state_provider.dart';

bool hasSubCategories(WidgetRef ref) {
  final categories = ref.read(mealsProvider);
  final selectedCategory = ref.read(selectedCategoryProvider);

  if (categories.isEmpty ||
      selectedCategory < 0 ||
      selectedCategory >= categories.length) {
    return false;
  }

  final selectedCat = categories[selectedCategory];
  return selectedCat.subCategories != null &&
      selectedCat.subCategories!.isNotEmpty;
}
