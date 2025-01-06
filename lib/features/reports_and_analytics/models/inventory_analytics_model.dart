import 'package:flutter/material.dart';

class InventoryAnalytics {
  final int totalProducts;
  final double inventoryValue;
  final int lowStockCount;
  final int outOfStockItems;
  final List<InventoryValuePoint> valueTrend;
  final List<CategoryDistribution> categoryDistribution;
  final List<LowStockItem> lowStockItems;
  final List<ExpiringItem> expiringItems;

  const InventoryAnalytics({
    required this.totalProducts,
    required this.inventoryValue,
    required this.lowStockCount,
    required this.outOfStockItems,
    required this.valueTrend,
    required this.categoryDistribution,
    required this.lowStockItems,
    required this.expiringItems,
  });

  factory InventoryAnalytics.empty() {
    return InventoryAnalytics(
      totalProducts: 0,
      inventoryValue: 0,
      lowStockCount: 0,
      outOfStockItems: 0,
      valueTrend: const [],
      categoryDistribution: const [],
      lowStockItems: const [],
      expiringItems: const [],
    );
  }
}

class InventoryValuePoint {
  final DateTime date;
  final double value;

  const InventoryValuePoint({
    required this.date,
    required this.value,
  });
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
}

class LowStockItem {
  final String id;
  final String name;
  final int stock;
  final int minimumStock;

  const LowStockItem({
    required this.id,
    required this.name,
    required this.stock,
    required this.minimumStock,
  });
}

class ExpiringItem {
  final String id;
  final String name;
  final String batchNumber;
  final int stock;
  final DateTime expiryDate;
  final int daysUntilExpiry;

  const ExpiringItem({
    required this.id,
    required this.name,
    required this.batchNumber,
    required this.stock,
    required this.expiryDate,
    required this.daysUntilExpiry,
  });
}
