class StockItem {
  final String id;
  final String name;
  final String category;
  final String manufacturer;
  final String batchNumber;
  final DateTime expiryDate;
  final int quantity;
  final double unitPrice;
  final double totalValue;
  final int minimumStockLevel;
  final int reorderLevel;
  final String location;
  final String barcode;
  final String description;
  final DateTime lastUpdated;
  final String lastUpdatedBy;
  final bool isActive;

  StockItem({
    required this.id,
    required this.name,
    required this.category,
    required this.manufacturer,
    required this.batchNumber,
    required this.expiryDate,
    required this.quantity,
    required this.unitPrice,
    required this.totalValue,
    required this.minimumStockLevel,
    required this.reorderLevel,
    required this.location,
    required this.barcode,
    required this.description,
    required this.lastUpdated,
    required this.lastUpdatedBy,
    required this.isActive,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      manufacturer: json['manufacturer'] as String,
      batchNumber: json['batchNumber'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalValue: (json['totalValue'] as num).toDouble(),
      minimumStockLevel: json['minimumStockLevel'] as int,
      reorderLevel: json['reorderLevel'] as int,
      location: json['location'] as String,
      barcode: json['barcode'] as String,
      description: json['description'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      lastUpdatedBy: json['lastUpdatedBy'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'manufacturer': manufacturer,
      'batchNumber': batchNumber,
      'expiryDate': expiryDate.toIso8601String(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalValue': totalValue,
      'minimumStockLevel': minimumStockLevel,
      'reorderLevel': reorderLevel,
      'location': location,
      'barcode': barcode,
      'description': description,
      'lastUpdated': lastUpdated.toIso8601String(),
      'lastUpdatedBy': lastUpdatedBy,
      'isActive': isActive,
    };
  }
}

class StockFilter {
  final String? searchQuery;
  final String? category;
  final String? manufacturer;
  final bool? lowStock;
  final bool? expiringSoon;
  final DateTime? expiryDateStart;
  final DateTime? expiryDateEnd;

  StockFilter({
    this.searchQuery,
    this.category,
    this.manufacturer,
    this.lowStock,
    this.expiringSoon,
    this.expiryDateStart,
    this.expiryDateEnd,
  });
}
