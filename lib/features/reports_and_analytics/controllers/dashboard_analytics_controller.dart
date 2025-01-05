import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/analytics_service.dart';
import '../models/dashboard_analytics_model.dart';

class DashboardAnalyticsController extends GetxController {
  final AnalyticsService _analyticsService;
  final Rx<DashboardAnalytics?> analytics = Rx<DashboardAnalytics?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedTimeRange = 'monthly'.obs;
  final RxString selectedChart = 'sales'.obs;

  DashboardAnalyticsController(this._analyticsService);

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    isLoading.value = true;
    try {
      analytics.value = await _analyticsService.getDashboardAnalytics();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load analytics: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateTimeRange(String range) {
    selectedTimeRange.value = range;
    loadAnalytics();
  }

  void updateChart(String chart) {
    selectedChart.value = chart;
  }

  List<SalesDataPoint> get chartData {
    if (analytics.value == null) return [];

    switch (selectedChart.value) {
      case 'sales':
        return analytics.value!.sales.salesTrend;
      case 'customers':
        return analytics.value!.customers.customerTrend;
      default:
        return [];
    }
  }

  String formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  String formatGrowth(double value) {
    final prefix = value >= 0 ? '+' : '';
    return '$prefix${formatPercentage(value)}';
  }

  Color getGrowthColor(double value) {
    if (value > 0) {
      return const Color(0xFF4CAF50); // Green
    } else if (value < 0) {
      return const Color(0xFFF44336); // Red
    } else {
      return const Color(0xFF9E9E9E); // Grey
    }
  }

  List<CategoryDistribution> get topCategories {
    if (analytics.value == null) return [];
    return analytics.value!.inventory.categoryDistribution
        .where((category) => category.percentage >= 10)
        .toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));
  }

  List<CustomerSegment> get customerSegments {
    if (analytics.value == null) return [];
    return analytics.value!.customers.segments
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));
  }

  Map<String, double> get inventoryMetrics {
    if (analytics.value == null) return {};
    final inventory = analytics.value!.inventory;
    return {
      'Total Products': inventory.totalProducts.toDouble(),
      'Low Stock': inventory.lowStockItems.toDouble(),
      'Out of Stock': inventory.outOfStockItems.toDouble(),
      'Expiring Soon': inventory.expiringItems.toDouble(),
      'Turnover Rate': inventory.turnoverRate,
    };
  }

  Map<String, double> get salesMetrics {
    if (analytics.value == null) return {};
    final sales = analytics.value!.sales;
    return {
      'Total Revenue': sales.totalRevenue,
      'Total Sales': sales.totalSales.toDouble(),
      'Average Order': sales.averageOrderValue,
      'Growth Rate': sales.growthRate,
    };
  }

  Map<String, double> get customerMetrics {
    if (analytics.value == null) return {};
    final customers = analytics.value!.customers;
    return {
      'Total Customers': customers.totalCustomers.toDouble(),
      'Growth Rate': customers.customerGrowthRate,
      'Average Value': customers.averageCustomerValue,
    };
  }
}
