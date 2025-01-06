class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int quantity;
  final String unit;
  final String manufacturer;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int minimumStockLevel;
  final String batchNumber;
  final String location;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.manufacturer,
    required this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
    required this.minimumStockLevel,
    required this.batchNumber,
    required this.location,
  });

  bool get isLowStock => quantity <= minimumStockLevel;
  bool get isExpiringSoon => expiryDate.difference(DateTime.now()).inDays <= 30;
  double get totalValue => price * quantity;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      manufacturer: json['manufacturer'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      minimumStockLevel: json['minimumStockLevel'] as int,
      batchNumber: json['batchNumber'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'manufacturer': manufacturer,
      'expiryDate': expiryDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'minimumStockLevel': minimumStockLevel,
      'batchNumber': batchNumber,
      'location': location,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? quantity,
    String? unit,
    String? manufacturer,
    DateTime? expiryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? minimumStockLevel,
    String? batchNumber,
    String? location,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      manufacturer: manufacturer ?? this.manufacturer,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      minimumStockLevel: minimumStockLevel ?? this.minimumStockLevel,
      batchNumber: batchNumber ?? this.batchNumber,
      location: location ?? this.location,
    );
  }
}
