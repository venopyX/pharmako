import 'package:flutter/material.dart';

class SalesAnalytics {
  final double totalRevenue;
  final int totalSales;
  final double averageOrderValue;
  final double growthRate;
  final List<SalesDataPoint> salesTrend;

  const SalesAnalytics({
    required this.totalRevenue,
    required this.totalSales,
    required this.averageOrderValue,
    required this.growthRate,
    required this.salesTrend,
  });

  factory SalesAnalytics.fromJson(Map<String, dynamic> json) {
    return SalesAnalytics(
      totalRevenue: json['totalRevenue'] as double,
      totalSales: json['totalSales'] as int,
      averageOrderValue: json['averageOrderValue'] as double,
      growthRate: json['growthRate'] as double,
      salesTrend: (json['salesTrend'] as List<dynamic>)
          .map((e) => SalesDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalRevenue': totalRevenue,
        'totalSales': totalSales,
        'averageOrderValue': averageOrderValue,
        'growthRate': growthRate,
        'salesTrend': salesTrend.map((e) => e.toJson()).toList(),
      };
}

class InventoryAnalytics {
  final int totalProducts;
  final int lowStockItems;
  final int outOfStockItems;
  final int expiringItems;
  final double inventoryValue;
  final double turnoverRate;
  final List<CategoryDistribution> categoryDistribution;

  const InventoryAnalytics({
    required this.totalProducts,
    required this.lowStockItems,
    required this.outOfStockItems,
    required this.expiringItems,
    required this.inventoryValue,
    required this.turnoverRate,
    required this.categoryDistribution,
  });

  factory InventoryAnalytics.fromJson(Map<String, dynamic> json) {
    return InventoryAnalytics(
      totalProducts: json['totalProducts'] as int,
      lowStockItems: json['lowStockItems'] as int,
      outOfStockItems: json['outOfStockItems'] as int,
      expiringItems: json['expiringItems'] as int,
      inventoryValue: json['inventoryValue'] as double,
      turnoverRate: json['turnoverRate'] as double,
      categoryDistribution: (json['categoryDistribution'] as List<dynamic>)
          .map((e) => CategoryDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalProducts': totalProducts,
        'lowStockItems': lowStockItems,
        'outOfStockItems': outOfStockItems,
        'expiringItems': expiringItems,
        'inventoryValue': inventoryValue,
        'turnoverRate': turnoverRate,
        'categoryDistribution':
            categoryDistribution.map((e) => e.toJson()).toList(),
      };
}

class CustomerAnalytics {
  final int totalCustomers;
  final double customerGrowthRate;
  final double averageCustomerValue;
  final List<CustomerSegment> segments;
  final List<SalesDataPoint> customerTrend;

  const CustomerAnalytics({
    required this.totalCustomers,
    required this.customerGrowthRate,
    required this.averageCustomerValue,
    required this.segments,
    required this.customerTrend,
  });

  factory CustomerAnalytics.fromJson(Map<String, dynamic> json) {
    return CustomerAnalytics(
      totalCustomers: json['totalCustomers'] as int,
      customerGrowthRate: json['customerGrowthRate'] as double,
      averageCustomerValue: json['averageCustomerValue'] as double,
      segments: (json['segments'] as List<dynamic>)
          .map((e) => CustomerSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerTrend: (json['customerTrend'] as List<dynamic>)
          .map((e) => SalesDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalCustomers': totalCustomers,
        'customerGrowthRate': customerGrowthRate,
        'averageCustomerValue': averageCustomerValue,
        'segments': segments.map((e) => e.toJson()).toList(),
        'customerTrend': customerTrend.map((e) => e.toJson()).toList(),
      };
}

class SalesDataPoint {
  final DateTime date;
  final double value;

  const SalesDataPoint({
    required this.date,
    required this.value,
  });

  factory SalesDataPoint.fromJson(Map<String, dynamic> json) {
    return SalesDataPoint(
      date: DateTime.parse(json['date'] as String),
      value: json['value'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'value': value,
      };
}

class CategoryDistribution {
  final String category;
  final int count;
  final double percentage;
  final Color color;

  const CategoryDistribution({
    required this.category,
    required this.count,
    required this.percentage,
    required this.color,
  });

  factory CategoryDistribution.fromJson(Map<String, dynamic> json) {
    return CategoryDistribution(
      category: json['category'] as String,
      count: json['count'] as int,
      percentage: json['percentage'] as double,
      color: Color(json['color'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'count': count,
        'percentage': percentage,
        'color': color.value,
      };
}

class CustomerSegment {
  final String name;
  final int count;
  final double percentage;
  final double totalValue;
  final Color color;

  const CustomerSegment({
    required this.name,
    required this.count,
    required this.percentage,
    required this.totalValue,
    required this.color,
  });

  factory CustomerSegment.fromJson(Map<String, dynamic> json) {
    return CustomerSegment(
      name: json['name'] as String,
      count: json['count'] as int,
      percentage: json['percentage'] as double,
      totalValue: json['totalValue'] as double,
      color: Color(json['color'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'count': count,
        'percentage': percentage,
        'totalValue': totalValue,
        'color': color.value,
      };
}

class DashboardAnalytics {
  final SalesAnalytics sales;
  final InventoryAnalytics inventory;
  final CustomerAnalytics customers;
  final DateTime lastUpdated;

  const DashboardAnalytics({
    required this.sales,
    required this.inventory,
    required this.customers,
    required this.lastUpdated,
  });

  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    return DashboardAnalytics(
      sales: SalesAnalytics.fromJson(json['sales'] as Map<String, dynamic>),
      inventory:
          InventoryAnalytics.fromJson(json['inventory'] as Map<String, dynamic>),
      customers:
          CustomerAnalytics.fromJson(json['customers'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'sales': sales.toJson(),
        'inventory': inventory.toJson(),
        'customers': customers.toJson(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}
