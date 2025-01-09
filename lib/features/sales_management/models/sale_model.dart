import 'package:get/get.dart';

class SaleItem {
  final String productId;
  final String productName;
  final double unitPrice;
  RxInt quantity;
  RxDouble totalPrice;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required int quantity,
  }) : 
    quantity = quantity.obs,
    totalPrice = (quantity * unitPrice).obs;

  void updateQuantity(int newQuantity) {
    quantity.value = newQuantity;
    totalPrice.value = newQuantity * unitPrice;
  }
}

class Sale {
  final String id;
  final DateTime timestamp;
  final List<SaleItem> items;
  final double totalAmount;

  Sale({
    required this.id,
    required this.timestamp,
    required this.items,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'items': items.map((item) => {
      'productId': item.productId,
      'productName': item.productName,
      'unitPrice': item.unitPrice,
      'quantity': item.quantity.value,
      'totalPrice': item.totalPrice.value,
    }).toList(),
    'totalAmount': totalAmount,
  };
}
