/// Model class representing dashboard summary data
class DashboardSummary {
  final int totalProducts;
  final int lowStockItems;
  final int expiringItems;
  final double totalSales;
  final int pendingAlerts;
  final int pendingOrders;  // Added for pending orders count
  final double profit;      // Added for profit tracking

  /// Creates a new dashboard summary instance
  const DashboardSummary({
    required this.totalProducts,
    required this.lowStockItems,
    required this.expiringItems,
    required this.totalSales,
    required this.pendingAlerts,
    required this.pendingOrders,
    required this.profit,
  });

  /// Creates an empty dashboard summary
  factory DashboardSummary.empty() {
    return const DashboardSummary(
      totalProducts: 0,
      lowStockItems: 0,
      expiringItems: 0,
      totalSales: 0,
      pendingAlerts: 0,
      pendingOrders: 0,
      profit: 0.0,
    );
  }

  /// Creates a copy of this dashboard summary with the given fields replaced with new values
  DashboardSummary copyWith({
    int? totalProducts,
    int? lowStockItems,
    int? expiringItems,
    double? totalSales,
    int? pendingAlerts,
    int? pendingOrders,
    double? profit,
  }) {
    return DashboardSummary(
      totalProducts: totalProducts ?? this.totalProducts,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      expiringItems: expiringItems ?? this.expiringItems,
      totalSales: totalSales ?? this.totalSales,
      pendingAlerts: pendingAlerts ?? this.pendingAlerts,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      profit: profit ?? this.profit,
    );
  }

  /// Converts this dashboard summary to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalProducts': totalProducts,
      'lowStockItems': lowStockItems,
      'expiringItems': expiringItems,
      'totalSales': totalSales,
      'pendingAlerts': pendingAlerts,
      'pendingOrders': pendingOrders,
      'profit': profit,
    };
  }

  /// Creates a dashboard summary from a JSON map
  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalProducts: json['totalProducts'] as int,
      lowStockItems: json['lowStockItems'] as int,
      expiringItems: json['expiringItems'] as int,
      totalSales: json['totalSales'] as double,
      pendingAlerts: json['pendingAlerts'] as int,
      pendingOrders: json['pendingOrders'] as int,
      profit: json['profit'] as double,
    );
  }
}
