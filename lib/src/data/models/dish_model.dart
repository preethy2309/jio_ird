class Dish {
  final int id;
  final String name;
  final String description;
  final String dishType;
  final String dishPrice;
  final String? dishImage;
  final String? fileType;
  final String? fileName;
  final String? allergies;
  final String? contains;
  String? cookingRequest;
  final int? quantity;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.dishType,
    required this.dishPrice,
    this.dishImage,
    this.fileType,
    this.fileName,
    this.allergies,
    this.contains,
    this.cookingRequest,
    this.quantity,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['dish_id'] is int ? json['dish_id'] : int.tryParse(json['dish_id'].toString()) ?? 0,
      name: json['dish_name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      dishType: json['dish_type'] as String? ?? "",
      dishPrice: json['dish_price'] as String? ?? "",
      dishImage: json['dish_image'] as String?,
      fileType: json['file_type'] as String?,
      fileName: json['file_name'] as String?,
      allergies: json['allergies'] as String?,
      contains: json['contains'] as String?,
      cookingRequest: json['cooking_request'] as String?,
      quantity: json['dish_qty'] is int ? json['dish_qty'] : int.tryParse(json['dish_qty']?.toString() ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish_id': id,
      'dish_name': name,
      'description': description,
      'dish_type': dishType,
      'dish_price': dishPrice,
      'dish_image': dishImage,
      'file_type': fileType,
      'file_name': fileName,
      'allergies': allergies,
      'contains': contains,
      'cooking_request': cookingRequest,
      'dish_qty': quantity,
    };
  }

  Dish copyWith({
    int? id,
    String? name,
    String? description,
    String? dishType,
    String? dishPrice,
    String? dishImage,
    String? fileType,
    String? fileName,
    String? allergies,
    String? contains,
    String? cookingRequest,
    int? quantity,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dishType: dishType ?? this.dishType,
      dishPrice: dishPrice ?? this.dishPrice,
      dishImage: dishImage ?? this.dishImage,
      fileType: fileType ?? this.fileType,
      fileName: fileName ?? this.fileName,
      allergies: allergies ?? this.allergies,
      contains: contains ?? this.contains,
      cookingRequest: cookingRequest ?? this.cookingRequest,
      quantity: quantity ?? this.quantity,
    );
  }
}
