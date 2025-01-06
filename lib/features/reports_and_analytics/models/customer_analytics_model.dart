import 'package:flutter/material.dart';

class CustomerAnalytics {
  final int totalCustomers;
  final int activeCustomers;
  final double averageCustomerValue;
  final double customerGrowthRate;
  final double activeCustomerRate;
  final double retentionRate;
  final List<CustomerTrendPoint> customerTrend;
  final List<CustomerSegment> segments;
  final List<TopCustomer> topCustomers;

  const CustomerAnalytics({
    required this.totalCustomers,
    required this.activeCustomers,
    required this.averageCustomerValue,
    required this.customerGrowthRate,
    required this.activeCustomerRate,
    required this.retentionRate,
    required this.customerTrend,
    required this.segments,
    required this.topCustomers,
  });

  factory CustomerAnalytics.empty() {
    return CustomerAnalytics(
      totalCustomers: 0,
      activeCustomers: 0,
      averageCustomerValue: 0,
      customerGrowthRate: 0,
      activeCustomerRate: 0,
      retentionRate: 0,
      customerTrend: [],
      segments: [],
      topCustomers: [],
    );
  }
}

class CustomerTrendPoint {
  final DateTime date;
  final int count;

  const CustomerTrendPoint({
    required this.date,
    required this.count,
  });
}

class CustomerSegment {
  final String name;
  final int count;
  final double percentage;
  final double averageValue;
  final Color color;

  const CustomerSegment({
    required this.name,
    required this.count,
    required this.percentage,
    required this.averageValue,
    required this.color,
  });
}

class TopCustomer {
  final String id;
  final String name;
  final String segment;
  final int totalOrders;
  final double totalValue;
  final DateTime lastOrder;

  const TopCustomer({
    required this.id,
    required this.name,
    required this.segment,
    required this.totalOrders,
    required this.totalValue,
    required this.lastOrder,
  });
}
