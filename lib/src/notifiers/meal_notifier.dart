import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/repository/data_repository.dart';

import '../data/models/food_item.dart';
import '../providers/data_repository_provider.dart';
import '../providers/external_providers.dart';

class MealsNotifier extends StateNotifier<List<FoodItem>> {
  final DataRepository repo;
  final String serialNum;
  final String propertyId;

  MealsNotifier(this.repo, this.serialNum, this.propertyId) : super([]) {
    loadMeals();
  }

  Future<void> loadMeals() async {
    try {
      final meals = await repo.fetchFoodDetails(serialNum, propertyId);
      final filteredMeals = meals.where((category) {
        category.subCategories?.removeWhere(
            (subCat) => (subCat.dishes == null || subCat.dishes!.isEmpty));

        final hasValidSubCats = category.subCategories != null &&
            category.subCategories!.isNotEmpty;
        final hasItems = category.dishes != null && category.dishes!.isNotEmpty;

        return hasValidSubCats || hasItems;
      }).toList();

      state = filteredMeals;
    } catch (e) {
      state = [];
    }
  }

  void updateDishCookingInstruction(int dishId, String newInstruction) {
    state = state.map((category) {
      FoodItem updateCategory(FoodItem cat) {
        final updatedDishes = cat.dishes?.map((dish) {
          if (dish.id == dishId) {
            return dish.copyWith(cookingRequest: newInstruction);
          }
          return dish;
        }).toList();

        final updatedSub = cat.subCategories?.map(updateCategory).toList();

        return cat.copyWith(
          dishes: updatedDishes,
          subCategories: updatedSub,
        );
      }

      return updateCategory(category);
    }).toList();
  }
}

final mealsProvider =
    StateNotifierProvider<MealsNotifier, List<FoodItem>>((ref) {
  final repo = ref.read(dataRepositoryProvider);
  final serialNum = ref.read(serialNumberProvider);
  final propertyId = ref.read(guestDetailsProvider).propertyId;
  return MealsNotifier(repo, serialNum, propertyId);
});
