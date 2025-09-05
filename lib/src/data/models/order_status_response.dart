class OrderStatusResponse {
  final int orderId;
  final String? guestName;
  final String? guestId;
  final String roomNo;
  final String displayId;
  final List<OrderDishDetail> dishDetails;

  OrderStatusResponse({
    required this.orderId,
    required this.guestName,
    required this.guestId,
    required this.roomNo,
    required this.displayId,
    required this.dishDetails,
  });

  factory OrderStatusResponse.fromJson(Map<String, dynamic> json) {
    return OrderStatusResponse(
      orderId: _toInt(json['order_id']),
      guestName: json['guest_name'] as String?,
      guestId: json['guest_id'] as String?,
      roomNo: json['room_no'] as String? ?? "",
      displayId: _toString(json['display_id']),
      dishDetails: (json['dish_details'] as List<dynamic>? ?? [])
          .map((e) => OrderDishDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'guest_name': guestName,
      'guest_id': guestId,
      'room_no': roomNo,
      'display_id': displayId,
      'dish_details': dishDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderDishDetail {
  final String name;
  final int quantity;
  final String price;
  final int id;
  final String dishType;
  final String status;
  final String image;

  OrderDishDetail({
    required this.name,
    required this.quantity,
    required this.price,
    required this.id,
    required this.dishType,
    required this.status,
    required this.image,
  });

  factory OrderDishDetail.fromJson(Map<String, dynamic> json) {
    return OrderDishDetail(
      name: json['name'] as String? ?? "",
      quantity: _toInt(json['quantity']),
      price: _toString(json['price']),
      id: _toInt(json['id']),
      dishType: json['dish_type'] as String? ?? "",
      status: json['status'] as String? ?? "",
      image: json['image'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'id': id,
      'dish_type': dishType,
      'status': status,
      'image': image,
    };
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _toString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}
