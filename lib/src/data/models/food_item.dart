import 'dish_model.dart';

class FoodItem {
  final int? id;
  final String? categoryName;
  final String? irdNote;
  final List<FoodItem>? subCategories;
  final List<Dish>? dishes;

  FoodItem({
    this.id,
    this.categoryName,
    this.irdNote,
    this.subCategories,
    this.dishes,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as int?,
      categoryName: json['category_name'] as String?,
      irdNote: json['ird_note'] as String?,
      subCategories: (json['sub_categories'] as List<dynamic>?)
          ?.map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dishes: (json['dishes'] as List<dynamic>?)
          ?.map((e) => Dish.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'ird_note': irdNote,
      'sub_categories': subCategories?.map((e) => e.toJson()).toList(),
      'dishes': dishes?.map((e) => e.toJson()).toList(),
    };
  }

  FoodItem copyWith({
    int? id,
    String? categoryName,
    String? irdNote,
    List<FoodItem>? subCategories,
    List<Dish>? dishes,
  }) {
    return FoodItem(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      irdNote: irdNote ?? this.irdNote,
      subCategories: subCategories ?? this.subCategories,
      dishes: dishes ?? this.dishes,
    );
  }
}