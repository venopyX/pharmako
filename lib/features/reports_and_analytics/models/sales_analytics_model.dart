class SalesAnalytics {
  final double totalRevenue;
  final int totalSales;
  final double averageOrderValue;
  final double growthRate;
  final double salesGrowthRate;
  final double orderValueGrowthRate;
  final double conversionRate;
  final double conversionRateGrowthRate;
  final List<SalesTrendPoint> salesTrend;
  final List<TopProduct> topProducts;
  final List<double> salesByHour;

  const SalesAnalytics({
    required this.totalRevenue,
    required this.totalSales,
    required this.averageOrderValue,
    required this.growthRate,
    required this.salesGrowthRate,
    required this.orderValueGrowthRate,
    required this.conversionRate,
    required this.conversionRateGrowthRate,
    required this.salesTrend,
    required this.topProducts,
    required this.salesByHour,
  });

  factory SalesAnalytics.empty() {
    return SalesAnalytics(
      totalRevenue: 0,
      totalSales: 0,
      averageOrderValue: 0,
      growthRate: 0,
      salesGrowthRate: 0,
      orderValueGrowthRate: 0,
      conversionRate: 0,
      conversionRateGrowthRate: 0,
      salesTrend: [],
      topProducts: [],
      salesByHour: List.filled(24, 0),
    );
  }
}

class SalesTrendPoint {
  final DateTime date;
  final double revenue;
  final int orders;
  final double averageOrder;

  const SalesTrendPoint({
    required this.date,
    required this.revenue,
    required this.orders,
    required this.averageOrder,
  });
}

class TopProduct {
  final String name;
  final String category;
  final int unitsSold;
  final double revenue;
  final double growthRate;

  const TopProduct({
    required this.name,
    required this.category,
    required this.unitsSold,
    required this.revenue,
    required this.growthRate,
  });
}

class SalesDataPoint {
  final DateTime date;
  final double value;

  const SalesDataPoint({
    required this.date,
    required this.value,
  });
}

class CustomerSegment {
  final String name;
  final String description;
  final Map<String, dynamic> criteria;
  final List<String> customerIds;
  final Map<String, double> metrics;

  const CustomerSegment({
    required this.name,
    required this.description,
    required this.criteria,
    required this.customerIds,
    required this.metrics,
  });

  factory CustomerSegment.empty() {
    return const CustomerSegment(
      name: '',
      description: '',
      criteria: {},
      customerIds: [],
      metrics: {},
    );
  }
}
