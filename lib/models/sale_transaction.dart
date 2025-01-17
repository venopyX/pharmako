import 'sale_item.dart';

/// Model class representing a sale transaction
class SaleTransaction {
  final String id;
  final List<SaleItem> items;
  final String customerName;
  final DateTime transactionDate;
  final String paymentMethod;
  final String status;
  final String? prescriptionId;

  const SaleTransaction({
    required this.id,
    required this.items,
    required this.customerName,
    required this.transactionDate,
    required this.paymentMethod,
    required this.status,
    this.prescriptionId,
  });

  /// Calculate the total amount for this transaction
  double get total => items.fold(0, (sum, item) => sum + item.total);

  /// Check if this transaction requires a prescription
  bool get requiresPrescription => items.any((item) => 
    item.product.metadata?['prescription'] == true);

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'customerName': customerName,
      'transactionDate': transactionDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'status': status,
      'prescriptionId': prescriptionId,
    };
  }

  /// Create from JSON
  factory SaleTransaction.fromJson(Map<String, dynamic> json) {
    return SaleTransaction(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => SaleItem.fromJson(item))
          .toList(),
      customerName: json['customerName'],
      transactionDate: DateTime.parse(json['transactionDate']),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      prescriptionId: json['prescriptionId'],
    );
  }
}
