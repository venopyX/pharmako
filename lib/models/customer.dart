/// Model class for customer data
class Customer {
  final String id;
  final String name;
  final int totalPurchases;
  final double totalSpent;
  final DateTime lastPurchase;
  final bool isActive;

  Customer({
    required this.id,
    required this.name,
    required this.totalPurchases,
    required this.totalSpent,
    required this.lastPurchase,
    required this.isActive,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      totalPurchases: json['total_purchases'] as int,
      totalSpent: (json['total_spent'] as num).toDouble(),
      lastPurchase: DateTime.parse(json['last_purchase'] as String),
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_purchases': totalPurchases,
      'total_spent': totalSpent,
      'last_purchase': lastPurchase.toIso8601String(),
      'is_active': isActive,
    };
  }
}
