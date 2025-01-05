import '../../features/reports_and_analytics/models/dashboard_analytics_model.dart';
import '../../features/reports_and_analytics/models/inventory_report_model.dart';
import '../repositories/analytics_repository.dart';

class AnalyticsService {
  final AnalyticsRepository _repository;

  AnalyticsService(this._repository);

  // Dashboard Analytics
  DashboardAnalytics getDashboardAnalytics() {
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

  List<SalesDataPoint> calculateMovingAverage(
    List<SalesDataPoint> data,
    int period,
  ) {
    if (data.length < period) return data;

    return List.generate(data.length - period + 1, (i) {
      final periodData = data.sublist(i, i + period);
      final average = periodData.map((e) => e.value).reduce((a, b) => a + b) /
          period;
      return SalesDataPoint(
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

  List<CustomerSegment> segmentCustomers(
    List<Map<String, dynamic>> customerData,
    Map<String, dynamic> segmentationRules,
  ) {
    // This is a placeholder for customer segmentation logic
    // In a real implementation, this would use the segmentation rules
    // to categorize customers based on their data
    return [];
  }

  Map<String, double> forecastDemand(
    List<SalesDataPoint> historicalData,
    int forecastPeriods,
  ) {
    // This is a placeholder for demand forecasting logic
    // In a real implementation, this would use time series analysis
    // or machine learning models to predict future demand
    return {};
  }

  Map<String, List<String>> identifyTrends(
    List<SalesDataPoint> salesData,
    Map<String, dynamic> parameters,
  ) {
    // This is a placeholder for trend analysis logic
    // In a real implementation, this would analyze the data
    // to identify significant patterns and trends
    return {};
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
