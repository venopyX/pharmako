import 'package:flutter/material.dart';

class OrderAnalytics {
  final int totalOrders;
  final double averageOrderValue;
  final int orderFrequency;
  final double orderGrowthRate;
  final double completionRate;
  final List<OrderTrendPoint> orderTrend;
  final List<OrderValueRange> valueDistribution;
  final List<OrderStatusDistribution> statusDistribution;
  final List<RecentOrder> recentOrders;

  const OrderAnalytics({
    required this.totalOrders,
    required this.averageOrderValue,
    required this.orderFrequency,
    required this.orderGrowthRate,
    required this.completionRate,
    required this.orderTrend,
    required this.valueDistribution,
    required this.statusDistribution,
    required this.recentOrders,
  });

  factory OrderAnalytics.empty() {
    return OrderAnalytics(
      totalOrders: 0,
      averageOrderValue: 0,
      orderFrequency: 0,
      orderGrowthRate: 0,
      completionRate: 0,
      orderTrend: [],
      valueDistribution: [],
      statusDistribution: [],
      recentOrders: [],
    );
  }
}

class OrderTrendPoint {
  final DateTime date;
  final int count;

  const OrderTrendPoint({
    required this.date,
    required this.count,
  });
}

class OrderValueRange {
  final String range;
  final int count;

  const OrderValueRange({
    required this.range,
    required this.count,
  });
}

class OrderStatusDistribution {
  final String name;
  final int count;
  final double percentage;
  final Color color;

  const OrderStatusDistribution({
    required this.name,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

class RecentOrder {
  final String id;
  final String customerName;
  final int itemCount;
  final double totalValue;
  final String status;
  final Color statusColor;
  final DateTime date;

  const RecentOrder({
    required this.id,
    required this.customerName,
    required this.itemCount,
    required this.totalValue,
    required this.status,
    required this.statusColor,
    required this.date,
  });
}
