import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/providers/external_providers.dart';

import '../data/models/dish_model.dart';
import '../data/models/food_item.dart';
import '../data/models/order_status_response.dart';
import '../notifiers/meal_notifier.dart';
import 'data_repository_provider.dart';

enum CartTab { cart, orders }

final orderStatusProvider =
    FutureProvider<List<OrderStatusResponse>>((ref) async {
  final repo = ref.read(dataRepositoryProvider);
  final serialNum = ref.read(serialNumberProvider);
  return repo.checkOrderStatus(serialNum);
});

final vegOnlyProvider = StateProvider<bool>((ref) => false);

/// Currently selected category index
final selectedCategoryProvider = StateProvider<int>((ref) => 0);

final selectedSubCategoryProvider = StateProvider<int>((ref) => -1);

final focusedSubCategoryProvider = StateProvider<int>((ref) => -1);

final selectedDishProvider = StateProvider<int>((ref) => -1);

final focusedDishProvider = StateProvider<int>((ref) => -1);

final showCategoriesProvider = StateProvider<bool>((ref) => true);

final showSubCategoriesProvider = StateProvider<bool>((ref) => true);

final selectedCartTabProvider = StateProvider<CartTab>((ref) => CartTab.cart);

final orderPlacedProvider = StateProvider<bool>((ref) => false);

final noDishesProvider = Provider<bool>((ref) {
  final vegOnly = ref.watch(vegOnlyProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final focusedSubCategory = ref.watch(focusedSubCategoryProvider);
  final categories = ref.watch(mealsProvider);

  if (categories.isEmpty) return true;

  final selectedCat = categories[selectedCategory];
  final allDishes = selectedCat.subCategories != null &&
          selectedCat.subCategories!.isNotEmpty &&
          focusedSubCategory >= 0
      ? extractDishesFromCategory(
          selectedCat.subCategories![focusedSubCategory])
      : extractDishesFromCategory(selectedCat);

  final filteredDishes = vegOnly
      ? allDishes
          .where((dish) => dish.dishType.toLowerCase() == 'veg')
          .toList()
      : allDishes;

  return filteredDishes.isEmpty;
});

List<Dish> extractDishesFromCategory(FoodItem category) {
  List<Dish> dishes = [];

  if (category.dishes != null) {
    dishes.addAll(category.dishes!);
  }

  if (category.subCategories != null) {
    for (final sub in category.subCategories!) {
      dishes.addAll(extractDishesFromCategory(sub));
    }
  }
  return dishes;
}
