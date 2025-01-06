import 'dart:math' as math;
import '../../features/reports_and_analytics/models/dashboard_analytics_model.dart' as dashboard;
import '../../features/reports_and_analytics/models/inventory_report_model.dart';
import '../../features/reports_and_analytics/models/sales_analytics_model.dart' as sales;
import '../repositories/analytics_repository.dart';

class AnalyticsService {
  final AnalyticsRepository _repository;

  AnalyticsService(this._repository);

  // Dashboard Analytics
  dashboard.DashboardAnalytics getDashboardAnalytics() {
    return _repository.getMockDashboardAnalytics();
  }

  // Inventory Reports
  InventoryReport generateInventoryReport(
    ReportType type,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _repository.getMockInventoryReport(type, startDate, endDate);
  }

  // Helper methods for common analytics calculations
  double calculateGrowthRate(double currentValue, double previousValue) {
    if (previousValue == 0) return 0;
    return ((currentValue - previousValue) / previousValue) * 100;
  }

  // Sales Analytics
  Future<sales.SalesAnalytics> getSalesAnalytics({
    required String period,
    required String metric,
  }) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      return _getMockSalesAnalytics(period: period, metric: metric);
    } catch (e) {
      rethrow;
    }
  }

  sales.SalesAnalytics _getMockSalesAnalytics({
    required String period,
    required String metric,
  }) {
    final now = DateTime.now();
    final random = math.Random();

    // Generate mock sales trend data
    final salesTrend = List.generate(
      24,
      (index) {
        final date = now.subtract(Duration(hours: 23 - index));
        final revenue = (random.nextDouble() * 1000) + 500;
        final orders = random.nextInt(20) + 10;
        return sales.SalesTrendPoint(
          date: date,
          revenue: revenue,
          orders: orders,
          averageOrder: revenue / orders,
        );
      },
    );

    // Generate mock top products
    final topProducts = List.generate(
      5,
      (index) {
        final unitsSold = random.nextInt(100) + 50;
        final revenue = (random.nextDouble() * 5000) + 1000;
        return sales.TopProduct(
          name: 'Product ${index + 1}',
          category: 'Category ${(index % 3) + 1}',
          unitsSold: unitsSold,
          revenue: revenue,
          growthRate: (random.nextDouble() * 20) - 10,
        );
      },
    );

    // Generate mock sales by hour
    final salesByHour = List.generate(
      24,
      (index) => (random.nextDouble() * 100) + 20,
    );

    return sales.SalesAnalytics(
      totalRevenue: 25000.0,
      totalSales: 150,
      averageOrderValue: 166.67,
      growthRate: 15.5,
      salesGrowthRate: 12.3,
      orderValueGrowthRate: 8.7,
      conversionRate: 3.2,
      conversionRateGrowthRate: 0.5,
      salesTrend: salesTrend,
      topProducts: topProducts,
      salesByHour: salesByHour,
    );
  }

  double calculateTurnoverRate(
    double totalSales,
    double averageInventoryValue,
  ) {
    if (averageInventoryValue == 0) return 0;
    return totalSales / averageInventoryValue;
  }

  Map<String, double> calculateCategoryPercentages(
    Map<String, double> categoryValues,
  ) {
    final total = categoryValues.values.fold<double>(0, (a, b) => a + b);
    return categoryValues.map(
      (key, value) => MapEntry(key, (value / total) * 100),
    );
  }

  double calculateAverageValue(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  List<sales.SalesDataPoint> calculateMovingAverage(
    List<sales.SalesDataPoint> data,
    int period,
  ) {
    if (data.length < period) return data;

    return List.generate(data.length - period + 1, (i) {
      final periodData = data.sublist(i, i + period);
      final average = periodData.map((e) => e.value).reduce((a, b) => a + b) /
          period;
      return sales.SalesDataPoint(
        date: periodData.last.date,
        value: average,
      );
    });
  }

  Map<String, double> calculateProductContribution(
    Map<String, double> productSales,
    double totalSales,
  ) {
    return productSales.map(
      (key, value) => MapEntry(key, (value / totalSales) * 100),
    );
  }

  List<sales.CustomerSegment> segmentCustomers(
    List<Map<String, dynamic>> customerData,
    Map<String, dynamic> segmentationRules,
  ) {
    final segments = <sales.CustomerSegment>[];
    
    // Define common customer segments
    final segmentDefinitions = {
      'high_value': {
        'name': 'High Value Customers',
        'description': 'Customers with high purchase value and frequency',
        'criteria': {
          'min_purchase_value': 1000,
          'min_purchase_frequency': 5,
        },
      },
      'regular': {
        'name': 'Regular Customers',
        'description': 'Customers with moderate purchase patterns',
        'criteria': {
          'min_purchase_value': 500,
          'min_purchase_frequency': 3,
        },
      },
      'new': {
        'name': 'New Customers',
        'description': 'Recently acquired customers',
        'criteria': {
          'max_customer_age_days': 30,
        },
      },
    };

    // Process each segment
    segmentDefinitions.forEach((key, definition) {
      final customerIds = customerData
          .where((customer) => _matchesSegmentCriteria(customer, definition['criteria'] as Map<String, dynamic>))
          .map((customer) => customer['id'] as String)
          .toList();

      if (customerIds.isNotEmpty) {
        segments.add(sales.CustomerSegment(
          name: definition['name'] as String,
          description: definition['description'] as String,
          criteria: definition['criteria'] as Map<String, dynamic>,
          customerIds: customerIds,
          metrics: _calculateSegmentMetrics(customerData, customerIds),
        ));
      }
    });

    return segments;
  }

  Map<String, double> forecastDemand(
    List<sales.SalesDataPoint> historicalData,
    int forecastPeriods,
  ) {
    if (historicalData.isEmpty || forecastPeriods <= 0) {
      return {};
    }

    // Calculate simple moving average for trend
    final movingAveragePeriod = 3;
    final trend = calculateMovingAverage(historicalData, movingAveragePeriod);
    
    // Calculate average growth rate
    double averageGrowthRate = 0;
    if (trend.length > 1) {
      double totalGrowthRate = 0;
      for (int i = 1; i < trend.length; i++) {
        if (trend[i - 1].value != 0) {
          totalGrowthRate += (trend[i].value - trend[i - 1].value) / trend[i - 1].value;
        }
      }
      averageGrowthRate = totalGrowthRate / (trend.length - 1);
    }

    // Generate forecast
    final forecast = <String, double>{};
    final lastValue = historicalData.last.value;
    
    for (int i = 1; i <= forecastPeriods; i++) {
      final forecastValue = lastValue * (1 + averageGrowthRate * i);
      forecast['period_$i'] = forecastValue;
    }

    return forecast;
  }

  Map<String, List<String>> identifyTrends(
    List<sales.SalesDataPoint> salesData,
    Map<String, dynamic> parameters,
  ) {
    final trends = <String, List<String>>{};
    
    if (salesData.isEmpty) {
      return trends;
    }

    // Calculate basic statistics
    final values = salesData.map((point) => point.value).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final minValue = values.reduce((a, b) => a < b ? a : b);

    // Identify overall trend
    final firstValue = salesData.first.value;
    final lastValue = salesData.last.value;
    final overallChange = ((lastValue - firstValue) / firstValue) * 100;

    // Identify seasonal patterns
    final seasonalPatterns = _identifySeasonalPatterns(salesData);

    // Identify anomalies
    final anomalies = _identifyAnomalies(salesData, average);

    // Compile trends
    trends['overall_trend'] = [
      if (overallChange > 5) 'Upward trend: ${overallChange.toStringAsFixed(1)}% increase',
      if (overallChange < -5) 'Downward trend: ${overallChange.toStringAsFixed(1)}% decrease',
      if (overallChange.abs() <= 5) 'Stable trend: ${overallChange.toStringAsFixed(1)}% change',
    ];

    // Add value range analysis
    trends['value_range'] = [
      'Maximum value: ${maxValue.toStringAsFixed(2)}',
      'Minimum value: ${minValue.toStringAsFixed(2)}',
      'Value range: ${(maxValue - minValue).toStringAsFixed(2)}',
    ];

    if (seasonalPatterns.isNotEmpty) {
      trends['seasonal_patterns'] = seasonalPatterns;
    }

    if (anomalies.isNotEmpty) {
      trends['anomalies'] = anomalies;
    }

    return trends;
  }

  bool _matchesSegmentCriteria(Map<String, dynamic> customer, Map<String, dynamic> criteria) {
    for (final entry in criteria.entries) {
      final value = customer[entry.key];
      final criterion = entry.value;
      
      if (entry.key.startsWith('min_') && (value == null || value < criterion)) {
        return false;
      }
      if (entry.key.startsWith('max_') && (value == null || value > criterion)) {
        return false;
      }
    }
    return true;
  }

  Map<String, double> _calculateSegmentMetrics(List<Map<String, dynamic>> customerData, List<String> customerIds) {
    final metrics = <String, double>{};
    final segmentCustomers = customerData.where((customer) => customerIds.contains(customer['id']));
    
    if (segmentCustomers.isEmpty) {
      return metrics;
    }

    // Calculate average purchase value
    final totalPurchaseValue = segmentCustomers
        .map((customer) => customer['total_purchase_value'] as double? ?? 0.0)
        .reduce((a, b) => a + b);
    metrics['avg_purchase_value'] = totalPurchaseValue / segmentCustomers.length;

    // Calculate average purchase frequency
    final totalPurchaseFrequency = segmentCustomers
        .map((customer) => customer['purchase_frequency'] as int? ?? 0)
        .reduce((a, b) => a + b);
    metrics['avg_purchase_frequency'] = totalPurchaseFrequency / segmentCustomers.length;

    return metrics;
  }

  List<String> _identifySeasonalPatterns(List<sales.SalesDataPoint> salesData) {
    final patterns = <String>[];
    final dailyAverages = <int, List<double>>{};

    // Group data by day of week
    for (final point in salesData) {
      final dayOfWeek = point.date.weekday;
      dailyAverages.putIfAbsent(dayOfWeek, () => []).add(point.value);
    }

    // Calculate average for each day
    dailyAverages.forEach((day, values) {
      final average = values.reduce((a, b) => a + b) / values.length;
      final dayName = _getDayName(day);
      patterns.add('$dayName: Average ${average.toStringAsFixed(2)}');
    });

    return patterns;
  }

  List<String> _identifyAnomalies(List<sales.SalesDataPoint> salesData, double average) {
    final anomalies = <String>[];
    final stdDev = _calculateStandardDeviation(salesData.map((p) => p.value).toList(), average);
    final threshold = 2 * stdDev; // 2 standard deviations

    for (final point in salesData) {
      if ((point.value - average).abs() > threshold) {
        anomalies.add(
          '${point.date.toString()}: ${point.value.toStringAsFixed(2)} (${(point.value > average ? 'above' : 'below')} normal range)',
        );
      }
    }

    return anomalies;
  }

  double _calculateStandardDeviation(List<double> values, double mean) {
    if (values.isEmpty) return 0;
    final squaredDiffs = values.map((value) => math.pow(value - mean, 2));
    return math.sqrt(squaredDiffs.reduce((a, b) => a + b) / values.length);
  }

  String _getDayName(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day - 1];
  }

  Map<String, double> calculateInventoryMetrics(
    List<InventoryReportItem> items,
  ) {
    if (items.isEmpty) return {};

    final totalValue =
        items.fold<double>(0, (sum, item) => sum + item.totalValue);
    final averageValue = totalValue / items.length;
    final stockTurnover = items.fold<int>(0, (sum, item) => sum + item.stockSold) /
        items.fold<int>(0, (sum, item) => sum + item.closingStock);

    return {
      'totalValue': totalValue,
      'averageValue': averageValue,
      'stockTurnover': stockTurnover,
      'lowStockPercentage':
          (items.where((item) => item.closingStock <= item.minimumStockLevel).length /
                  items.length) *
              100,
      'outOfStockPercentage':
          (items.where((item) => item.closingStock == 0).length / items.length) *
              100,
    };
  }
}
