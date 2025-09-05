class OrderRequest {
  final List<OrderDish> dishDetails;
  final String roomNo;
  final String serialNum;

  OrderRequest({
    required this.dishDetails,
    required this.roomNo,
    required this.serialNum,
  });

  Map<String, dynamic> toJson() {
    return {
      'dish_details': dishDetails.map((d) => d.toJson()).toList(),
      'room_no': roomNo,
      'serial_Num': serialNum,
    };
  }
}

class OrderDish {
  final String id;
  final String quantity;
  final String cookingRequest;
  final String status;

  OrderDish({
    required this.id,
    required this.quantity,
    required this.cookingRequest,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'cooking_request': cookingRequest,
      'status': status,
    };
  }
}
