import 'package:flutter/material.dart';

// Dashboard models

enum AlertType {
  lowStock,
  expiring,
  highDemand,
  outOfStock,
  priceChange,
}

class DashboardSummary {
  final int totalProducts;
  final int lowStockItems;
  final int expiringItems;
  final double totalSales;
  final int pendingAlerts;

  DashboardSummary({
    this.totalProducts = 0,
    this.lowStockItems = 0,
    this.expiringItems = 0,
    this.totalSales = 0.0,
    this.pendingAlerts = 0,
  });
}

class DashboardChartData {
  final String label;
  final double value;

  DashboardChartData({
    required this.label,
    required this.value,
  });
}

class DashboardAlert {
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;

  DashboardAlert({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  Color get color {
    switch (type) {
      case AlertType.lowStock:
        return Colors.orange;
      case AlertType.expiring:
        return Colors.red;
      case AlertType.highDemand:
        return Colors.green;
      case AlertType.outOfStock:
        return Colors.red.shade700;
      case AlertType.priceChange:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (type) {
      case AlertType.lowStock:
        return Icons.warning;
      case AlertType.expiring:
        return Icons.timer;
      case AlertType.highDemand:
        return Icons.trending_up;
      case AlertType.outOfStock:
        return Icons.remove_shopping_cart;
      case AlertType.priceChange:
        return Icons.attach_money;
    }
  }
}