import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/dish_model.dart';
import '../../data/models/food_item.dart';
import '../../notifiers/meal_notifier.dart';
import '../../providers/external_providers.dart';
import '../../providers/focus_provider.dart';
import '../../providers/state_provider.dart';
import '../../utils/helper.dart';
import '../widgets/menu/category_list.dart';
import '../widgets/menu/dish_detail.dart';
import '../widgets/menu/dish_list.dart';
import '../widgets/menu/menu_top_bar/cart_button.dart';
import '../widgets/menu/menu_top_bar/veg_toggle.dart';
import '../widgets/menu/sub_categories_with_image.dart';
import '../widgets/menu/sub_category_list.dart';
import '../widgets/shimmer_loader.dart';
import 'base_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final vegOnly = ref.watch(vegOnlyProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final focusedSubCategory = ref.watch(focusedSubCategoryProvider);
    final focusedDish = ref.watch(focusedDishProvider);
    final categories = ref.watch(mealsProvider);
    final showCategories = ref.watch(showCategoriesProvider);
    final showSubCategories = ref.watch(showSubCategoriesProvider);
    final menuTitle = ref.watch(menuTitleProvider);

    ref.listen<bool>(vegOnlyProvider, (previous, next) {
      if (previous != next) {
        ref.read(selectedCategoryProvider.notifier).state = 0;
        ref.read(selectedSubCategoryProvider.notifier).state = -1;
        ref.read(focusedSubCategoryProvider.notifier).state = -1;
        ref.read(selectedDishProvider.notifier).state = -1;
        ref.read(focusedDishProvider.notifier).state = -1;
        ref.read(showCategoriesProvider.notifier).state = true;
        ref.read(showSubCategoriesProvider.notifier).state = true;
        ref.read(isSubCategoryListFocusedProvider.notifier).state = false;
        ref.read(isCategoryFocusedProvider.notifier).state = false;
        ref.read(isDishFocusedProvider.notifier).state = false;

        ref.invalidate(mealsProvider);

        final index = ref.read(selectedCategoryProvider);
        ref.read(categoryFocusNodeProvider(index)).requestFocus();
      }
    });

    if (categories.isEmpty) {
      return BaseScreen(
        title: menuTitle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List.generate(
                6,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: ShimmerLoader(height: 40, width: 180),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: List.generate(
                5,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: ShimmerLoader(height: 70, width: 240),
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(
              width: 432,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoader(height: 200, width: double.infinity),
                  SizedBox(height: 16),
                  ShimmerLoader(height: 20, width: 150),
                  SizedBox(height: 8),
                  ShimmerLoader(height: 20, width: 200),
                  SizedBox(height: 8),
                  ShimmerLoader(height: 20, width: 120),
                ],
              ),
            ),
          ],
        ),
      );
    }

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

    if (categories.isNotEmpty &&
        !ref.watch(vegToggleFocusNodeProvider).hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (showCategories) {
          var index = selectedCategory == -1 ? 0 : selectedCategory;
          ref.read(categoryFocusNodeProvider(index)).requestFocus();
        } else if (hasSubCategories(ref) && showSubCategories) {
          var index = ref.watch(focusedSubCategoryProvider);
          ref
              .read(subCategoryFocusNodeProvider(index == -1 ? 0 : index))
              .requestFocus();
        } else if (filteredDishes.isNotEmpty) {
          var index = ref.watch(focusedDishProvider);
          ref
              .read(dishFocusNodeProvider(index == -1 ? 0 : index))
              .requestFocus();
        }
      });
    }

    return BaseScreen(
      title: menuTitle,
      icons: const [VegToggle(), CartButton()],
      child: Row(
        children: [
          if (!showCategories || !showSubCategories)
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
            ),

          // --- CASE 1: Category + Dish List + Dish Detail ---
          if (showCategories && !hasSubCategories(ref)) ...[
            SizedBox(
              width: 202,
              child: CategoryList(categories: categories),
            ),
            const SizedBox(width: 16),
            if (filteredDishes.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No dishes available",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              )
            else ...[
              SizedBox(
                width: 240,
                child: DishList(dishes: filteredDishes),
              ),
              Spacer(),
              SizedBox(
                width: 432,
                child: DishDetail(
                  dish:
                      (focusedDish >= 0 && focusedDish < filteredDishes.length)
                          ? filteredDishes[focusedDish]
                          : filteredDishes.first,
                  categoryName: selectedCat.categoryName ?? '',
                  itemCount: filteredDishes.length,
                ),
              ),
            ],
          ]

          // --- CASE 2: Category + SubCategory + Dish Detail ---
          else if (showCategories &&
              hasSubCategories(ref) &&
              showSubCategories) ...[
            SizedBox(
              width: 202,
              child: CategoryList(categories: categories),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 240,
              child: SubCategoriesWithImage(
                  subCategories: selectedCat.subCategories!),
            ),
            Spacer(),
            if (filteredDishes.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No dishes available",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              )
            else
              SizedBox(
                width: 432,
                child: DishDetail(
                  dish:
                      (focusedDish >= 0 && focusedDish < filteredDishes.length)
                          ? filteredDishes[focusedDish]
                          : filteredDishes.first,
                  categoryName: selectedCat.categoryName ?? '',
                  itemCount: filteredDishes.length,
                ),
              ),
          ]

          // --- CASE 3: SubCategory + Dish List + Dish Detail ---
          else if (hasSubCategories(ref) && showSubCategories) ...[
            SizedBox(
              width: 330,
              child: SubCategoryList(subCategories: selectedCat.subCategories!),
            ),
            const SizedBox(width: 16),
            if (filteredDishes.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No dishes available",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              )
            else ...[
              // SizedBox(
              //   width: 280,
              //   child: DishList(dishes: filteredDishes),
              // ),
              Spacer(),
              SizedBox(
                width: 432,
                child: DishDetail(
                  dish:
                      (focusedDish >= 0 && focusedDish < filteredDishes.length)
                          ? filteredDishes[focusedDish]
                          : filteredDishes.first,
                  categoryName: selectedCat
                          .subCategories![
                              focusedSubCategory >= 0 ? focusedSubCategory : 0]
                          .categoryName ??
                      '',
                  itemCount: filteredDishes.length,
                ),
              ),
            ],
          ]

          // --- CASE 4: Only Dish List + Dish Detail ---
          else ...[
            if (filteredDishes.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No dishes available",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              )
            else ...[
              SizedBox(
                width: 280,
                child: DishList(dishes: filteredDishes),
              ),
              Spacer(),
              SizedBox(
                width: 432,
                child: DishDetail(
                  dish:
                      (focusedDish >= 0 && focusedDish < filteredDishes.length)
                          ? filteredDishes[focusedDish]
                          : filteredDishes.first,
                  categoryName: selectedCat.categoryName ?? '',
                  itemCount: filteredDishes.length,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

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
}
