import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../data/services/analytics_service.dart';
import '../models/inventory_report_model.dart';
import '../../../utils/constants/colors.dart';

enum ReportFormat { pdf, excel, csv }

class AnalyticsReportController extends GetxController {
  final AnalyticsService _analyticsService;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;
  final RxString selectedCategory = 'All'.obs;
  final RxSet<String> selectedMetrics = <String>{}.obs;
  final RxString topProductsMetric = 'revenue'.obs;
  
  // Analytics data
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble revenueGrowth = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble averageOrderValue = 0.0.obs;
  final RxInt totalProducts = 0.obs;
  final RxInt lowStockItems = 0.obs;
  final RxInt totalCustomers = 0.obs;
  final RxInt newCustomers = 0.obs;
  final RxList<dynamic> topProducts = <dynamic>[].obs;

  AnalyticsReportController(this._analyticsService);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadOverviewData(),
        loadSalesData(),
        loadInventoryData(),
        loadCustomerData(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load analytics data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadOverviewData() async {
    final overview = await _analyticsService.getOverviewData(
      startDate.value,
      endDate.value,
    );
    totalRevenue.value = overview.totalRevenue;
    revenueGrowth.value = overview.revenueGrowth;
    totalOrders.value = overview.totalOrders;
    averageOrderValue.value = overview.averageOrderValue;
    totalProducts.value = overview.totalProducts;
    lowStockItems.value = overview.lowStockItems;
    totalCustomers.value = overview.totalCustomers;
    newCustomers.value = overview.newCustomers;
  }

  Future<void> loadSalesData() async {
    // Implementation for loading sales data
  }

  Future<void> loadInventoryData() async {
    // Implementation for loading inventory data
  }

  Future<void> loadCustomerData() async {
    // Implementation for loading customer data
  }

  void refreshData() {
    loadData();
  }

  void updateDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    loadData();
  }

  void updateTopProductsMetric(String? value) {
    if (value != null) {
      topProductsMetric.value = value;
      loadData();
    }
  }

  void exportReport(ReportFormat format) async {
    isLoading.value = true;
    try {
      final fileName = await _analyticsService.exportReport(
        startDate.value,
        endDate.value,
        format.toString(),
      );
      Get.snackbar(
        'Success',
        'Report exported as $fileName',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export report: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    loadData();
  }

  // Formatting methods
  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  String formatDateShort(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
  }

  String formatNumber(num value) {
    return NumberFormat('#,##0').format(value);
  }

  String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  // Chart data
  LineChartData get revenueChartData {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 3),
            const FlSpot(2.6, 2),
            const FlSpot(4.9, 5),
            const FlSpot(6.8, 3.1),
            const FlSpot(8, 4),
            const FlSpot(9.5, 3),
            const FlSpot(11, 4),
          ],
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: true),
        ),
      ],
    );
  }

  // Available options
  List<String> get categories => ['All', 'Medicine', 'Supplements', 'Equipment'];
  
  List<String> get availableMetrics => [
    'Revenue',
    'Orders',
    'Products',
    'Customers',
    'Stock Value',
    'Stock Movement',
  ];
}
