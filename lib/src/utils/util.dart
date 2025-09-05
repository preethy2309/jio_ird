import '../data/models/dish_with_quantity.dart';
import '../data/models/order_request.dart';

OrderRequest createOrderRequestFromDishWithQuantity(
  List<DishWithQuantity> items,
  String serialNum,
  String roomNo,
) {
  List<OrderDish> orderDishes = items.map((item) {
    return OrderDish(
      id: item.dish.id.toString(),
      quantity: item.quantity.toString(),
      cookingRequest: item.cookingRequest.toString(),
      status: "Submitted",
    );
  }).toList();

  return OrderRequest(
    dishDetails: orderDishes,
    roomNo: roomNo,
    serialNum: serialNum,
  );
}
