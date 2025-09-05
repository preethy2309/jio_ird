import 'package:jio_ird/src/data/models/dish_model.dart';

class DishWithQuantity {
  final Dish dish;
  final int quantity;
  final String? cookingRequest;

  DishWithQuantity({
    required this.dish,
    required this.quantity,
    this.cookingRequest,
  });

  DishWithQuantity copyWith({
    Dish? dish,
    int? quantity,
    String? cookingRequest,
  }) {
    return DishWithQuantity(
      dish: dish ?? this.dish,
      quantity: quantity ?? this.quantity,
      cookingRequest: cookingRequest ?? this.cookingRequest,
    );
  }

  factory DishWithQuantity.fromJson(Map<String, dynamic> json) {
    return DishWithQuantity(
      dish: Dish.fromJson(json['dish']),
      quantity: json['quantity'],
      cookingRequest: json['cookingRequest'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish': dish.toJson(),
      'quantity': quantity,
      'cookingRequest': cookingRequest,
    };
  }
}