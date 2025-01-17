import 'package:pharmako/models/inventory_item.dart';

/// Model class representing an item in a sale transaction
class SaleItem {
  final InventoryItem product;
  final int quantity;
  final double priceAtSale;

  const SaleItem({
    required this.product,
    required this.quantity,
    required this.priceAtSale,
  });

  /// Calculate the total price for this item
  double get total => quantity * priceAtSale;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'priceAtSale': priceAtSale,
    };
  }

  /// Create from JSON
  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      product: InventoryItem.fromJson(json['product']),
      quantity: json['quantity'],
      priceAtSale: json['priceAtSale'],
    );
  }
}
