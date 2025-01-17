/// Model class representing an inventory item in the pharmacy
class InventoryItem {
  final String id;
  final String name;
  final String description;
  final String category;
  final int quantity;
  final int minQuantity;
  final DateTime expiryDate;
  final double price;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.minQuantity,
    required this.expiryDate,
    required this.price,
    this.imageUrl,
    this.metadata,
  });

  /// Factory constructor to create an InventoryItem from JSON
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      quantity: json['quantity'] as int,
      minQuantity: json['minQuantity'] as int,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert InventoryItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'quantity': quantity,
      'minQuantity': minQuantity,
      'expiryDate': expiryDate.toIso8601String(),
      'price': price,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }

  /// Check if the item is low on stock
  bool get isLowStock => quantity < minQuantity;

  /// Check if the item is expiring soon (within 30 days)
  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30;
  }

  /// Create a copy of this item with updated fields
  InventoryItem copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? quantity,
    int? minQuantity,
    DateTime? expiryDate,
    double? price,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      expiryDate: expiryDate ?? this.expiryDate,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'InventoryItem(id: $id, name: $name, quantity: $quantity)';
  }
}
