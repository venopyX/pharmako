// TODO: Dashboard model 

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