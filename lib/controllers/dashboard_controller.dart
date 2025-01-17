import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_summary.dart';
import '../models/alert.dart';
import '../models/sales_data.dart';
import '../services/activity_log_service.dart';

/// Controller for managing the dashboard screen
class DashboardController extends GetxController {
  final ActivityLogService _activityLogService;
  final isLoading = false.obs;
  final summary = const DashboardSummary(
    totalProducts: 0,
    lowStockItems: 0,
    expiringItems: 0,
    totalSales: 0,
    pendingAlerts: 0,
    pendingOrders: 0,
    profit: 0.0,
  ).obs;
  final salesData = <SalesData>[].obs;
  final recentAlerts = <Alert>[].obs;
  final dateRangeText = ''.obs;
  final selectedRange = 'Last 7 Days'.obs;
  final selectedChartType = 'Daily'.obs;
  final salesTrend = 0.0.obs;
  final lowStockTrend = 0.0.obs;
  final expiryTrend = 0.0.obs;
  final ordersTrend = 0.0.obs;
  final profitTrend = 0.0.obs;
  final categoryData = <ChartData>[].obs;
  final revenueData = <ChartData>[].obs;
  final topProducts = <ProductData>[].obs;
  final upcomingExpiries = <ExpiryData>[].obs;

  DashboardController() : _activityLogService = Get.find<ActivityLogService>();

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
    _setupDateRange();
  }

  Future<void> refreshDashboard() async {
    try {
      isLoading.value = true;
      await _loadDashboardData();
      Get.snackbar(
        'Success',
        'Dashboard refreshed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh dashboard: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      selectedRange.value = 'Custom Range';
      _updateDateRange(picked);
      await refreshDashboard();
    }
  }

  void updateDateRange(String? range) {
    if (range != null) {
      selectedRange.value = range;
      final now = DateTime.now();
      DateTimeRange dateRange;

      switch (range) {
        case 'Today':
          dateRange = DateTimeRange(start: now, end: now);
          break;
        case 'Yesterday':
          final yesterday = now.subtract(const Duration(days: 1));
          dateRange = DateTimeRange(start: yesterday, end: yesterday);
          break;
        case 'Last 7 Days':
          dateRange = DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          );
          break;
        case 'Last 30 Days':
          dateRange = DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          );
          break;
        case 'This Month':
          dateRange = DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          );
          break;
        case 'Last Month':
          final lastMonth = DateTime(now.year, now.month - 1);
          dateRange = DateTimeRange(
            start: DateTime(lastMonth.year, lastMonth.month, 1),
            end: DateTime(now.year, now.month, 0),
          );
          break;
        default:
          return;
      }

      _updateDateRange(dateRange);
      refreshDashboard();
    }
  }

  void updateChartType(String? type) {
    if (type != null) {
      selectedChartType.value = type;
      _loadChartData();
    }
  }

  void _setupDateRange() {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    _updateDateRange(DateTimeRange(start: lastWeek, end: now));
  }

  void _updateDateRange(DateTimeRange range) {
    final formatter = DateFormat('MMM d, y');
    dateRangeText.value = '${formatter.format(range.start)} - ${formatter.format(range.end)}';
  }

  Future<void> _loadDashboardData() async {
    try {
      await Future.wait([
        _loadSummary(),
        _loadChartData(),
        _loadAlerts(),
        _loadTopProducts(),
        _loadUpcomingExpiries(),
      ]);
      _activityLogService.log('Dashboard data loaded');
    } catch (e) {
      _activityLogService.logError('Failed to load dashboard data: $e');
      rethrow;
    }
  }

  Future<void> _loadSummary() async {
    // TODO: Implement API call to fetch summary data
    summary.value = const DashboardSummary(
      totalProducts: 1250,
      lowStockItems: 45,
      expiringItems: 32,
      totalSales: 25678.90,
      pendingAlerts: 15,
      pendingOrders: 78,
      profit: 5432.10,
    );

    // TODO: Implement trend calculations from API
    salesTrend.value = 12.5;
    lowStockTrend.value = -5.2;
    expiryTrend.value = 8.7;
    ordersTrend.value = 15.3;
    profitTrend.value = 10.8;
  }

  Future<void> _loadChartData() async {
    // TODO: Implement API call to fetch chart data
    salesData.value = [
      const SalesData(
        label: 'Mon',
        value: 1500,
      ),
      const SalesData(
        label: 'Tue',
        value: 2300,
      ),
      const SalesData(
        label: 'Wed',
        value: 1800,
      ),
      const SalesData(
        label: 'Thu',
        value: 2800,
      ),
      const SalesData(
        label: 'Fri',
        value: 2100,
      ),
      const SalesData(
        label: 'Sat',
        value: 3200,
      ),
      const SalesData(
        label: 'Sun',
        value: 2700,
      ),
    ];

    categoryData.value = [
      const ChartData(
        label: 'Antibiotics',
        value: 30,
        color: Colors.blue,
      ),
      const ChartData(
        label: 'Pain Relief',
        value: 25,
        color: Colors.green,
      ),
      const ChartData(
        label: 'Vitamins',
        value: 20,
        color: Colors.orange,
      ),
      const ChartData(
        label: 'First Aid',
        value: 15,
        color: Colors.red,
      ),
      const ChartData(
        label: 'Others',
        value: 10,
        color: Colors.purple,
      ),
    ];

    revenueData.value = [
      const ChartData(
        label: 'Prescription',
        value: 45,
        color: Colors.blue,
      ),
      const ChartData(
        label: 'OTC',
        value: 35,
        color: Colors.green,
      ),
      const ChartData(
        label: 'Generics',
        value: 20,
        color: Colors.orange,
      ),
    ];
  }

  Future<void> _loadAlerts() async {
    // TODO: Implement API call to fetch alerts
    recentAlerts.value = [
      Alert(
        id: '1',
        title: 'Low Stock Alert',
        message: 'Paracetamol stock is running low',
        type: AlertType.warning,
        timestamp: DateTime.now(),
      ),
      Alert(
        id: '2',
        title: 'Expiry Alert',
        message: 'Batch AB123 expires in 30 days',
        type: AlertType.danger,
        timestamp: DateTime.now(),
      ),
      Alert(
        id: '3',
        title: 'Order Alert',
        message: 'New order #12345 received',
        type: AlertType.info,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> _loadTopProducts() async {
    // TODO: Implement API call to fetch top products
    topProducts.value = [
      const ProductData(
        name: 'Paracetamol',
        category: 'Pain Relief',
        sales: 150,
        revenue: 1500.00,
        stock: 200,
      ),
      const ProductData(
        name: 'Amoxicillin',
        category: 'Antibiotics',
        sales: 120,
        revenue: 2400.00,
        stock: 180,
      ),
      const ProductData(
        name: 'Vitamin C',
        category: 'Vitamins',
        sales: 100,
        revenue: 1000.00,
        stock: 300,
      ),
      const ProductData(
        name: 'Bandages',
        category: 'First Aid',
        sales: 80,
        revenue: 800.00,
        stock: 250,
      ),
      const ProductData(
        name: 'Ibuprofen',
        category: 'Pain Relief',
        sales: 75,
        revenue: 1125.00,
        stock: 150,
      ),
    ];
  }

  Future<void> _loadUpcomingExpiries() async {
    // TODO: Implement API call to fetch upcoming expiries
    upcomingExpiries.value = [
      const ExpiryData(
        productName: 'Amoxicillin',
        batchNumber: 'ABC123',
        quantity: 100,
        expiryDate: '2025-02-15',
        daysLeft: 29,
      ),
      const ExpiryData(
        productName: 'Paracetamol',
        batchNumber: 'XYZ789',
        quantity: 150,
        expiryDate: '2025-03-01',
        daysLeft: 43,
      ),
      const ExpiryData(
        productName: 'Vitamin C',
        batchNumber: 'DEF456',
        quantity: 200,
        expiryDate: '2025-03-15',
        daysLeft: 57,
      ),
      const ExpiryData(
        productName: 'Ibuprofen',
        batchNumber: 'GHI789',
        quantity: 80,
        expiryDate: '2025-02-28',
        daysLeft: 42,
      ),
      const ExpiryData(
        productName: 'Bandages',
        batchNumber: 'JKL012',
        quantity: 120,
        expiryDate: '2025-02-20',
        daysLeft: 34,
      ),
    ];
  }

  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Data class for chart data
class ChartData {
  final String label;
  final double value;
  final Color color;

  const ChartData({required this.label, required this.value, required this.color});
}

/// Data class for product data
class ProductData {
  final String name;
  final String category;
  final int sales;
  final double revenue;
  final int stock;

  const ProductData({
    required this.name,
    required this.category,
    required this.sales,
    required this.revenue,
    required this.stock,
  });
}

/// Data class for expiry data
class ExpiryData {
  final String productName;
  final String batchNumber;
  final int quantity;
  final String expiryDate;
  final int daysLeft;

  const ExpiryData({
    required this.productName,
    required this.batchNumber,
    required this.quantity,
    required this.expiryDate,
    required this.daysLeft,
  });
}
