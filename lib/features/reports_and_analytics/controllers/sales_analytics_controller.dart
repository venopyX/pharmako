import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/sales_analytics_model.dart';
import '../../../data/services/analytics_service.dart';

class SalesAnalyticsController extends GetxController {
  final AnalyticsService _analyticsService;
  final isLoading = false.obs;
  final analytics = SalesAnalytics.empty().obs;
  final selectedMetric = 'Revenue'.obs;
  final selectedPeriod = '30 Days'.obs;

  SalesAnalyticsController(this._analyticsService);

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      SalesAnalytics data;
      try {
        data = await _analyticsService.getSalesAnalytics(
          period: selectedPeriod.value,
          metric: selectedMetric.value,
        );
      } catch (serviceError) {
        // Fallback to mock data if service fails
        print('Warning: Using mock data - ${serviceError.toString()}');
        data = _getMockData();
      }
      analytics.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load sales analytics data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateMetric(String? metric) {
    if (metric != null) {
      selectedMetric.value = metric;
    }
  }

  void updatePeriod(String? period) {
    if (period != null) {
      selectedPeriod.value = period;
      refreshData();
    }
  }

  List<FlSpot> getChartData() {
    final data = analytics.value.salesTrend;
    return data.asMap().entries.map((entry) {
      final point = entry.value;
      double value;
      switch (selectedMetric.value) {
        case 'Revenue':
          value = point.revenue;
          break;
        case 'Orders':
          value = point.orders.toDouble();
          break;
        case 'Average Order':
          value = point.averageOrder;
          break;
        default:
          value = point.revenue;
      }
      return FlSpot(entry.key.toDouble(), value);
    }).toList();
  }

  String formatMetricValue(double value) {
    switch (selectedMetric.value) {
      case 'Revenue':
        return formatCurrencyCompact(value);
      case 'Orders':
        return formatNumber(value);
      case 'Average Order':
        return formatCurrency(value);
      default:
        return value.toString();
    }
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(symbol: '\$').format(value);
  }

  String formatCurrencyCompact(double value) {
    return NumberFormat.compactCurrency(symbol: '\$').format(value);
  }

  String formatNumber(double value) {
    return NumberFormat.compact().format(value);
  }

  String formatDateShort(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  Future<void> exportReport() async {
    // TODO: Implement report export
    Get.snackbar(
      'Export',
      'Report export feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  SalesAnalytics _getMockData() {
    final now = DateTime.now();
    final daysInPeriod = selectedPeriod.value == '7 Days'
        ? 7
        : selectedPeriod.value == '30 Days'
            ? 30
            : 90;
    final startDate = now.subtract(Duration(days: daysInPeriod));

    // Generate mock sales trend data
    final salesTrend = List.generate(daysInPeriod, (index) {
      final date = startDate.add(Duration(days: index));
      final baseRevenue = 1000.0 + (index * 50);
      final variance = (index % 3 == 0 ? 200.0 : 0.0) +
          (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday
              ? -200.0
              : 0.0);
      final revenue = baseRevenue + variance;
      final orders = (revenue / 50).round();
      return SalesTrendPoint(
        date: date,
        revenue: revenue,
        orders: orders,
        averageOrder: revenue / orders,
      );
    });

    // Generate mock top products
    final topProducts = List.generate(10, (index) {
      final baseUnits = 100 - (index * 8);
      final baseRevenue = baseUnits * (50 + index);
      final growthRate = 15.0 - (index * 2) + (index % 2 == 0 ? 5 : -5);
      return TopProduct(
        name: 'Product ${index + 1}',
        category: index % 3 == 0
            ? 'Pain Relief'
            : index % 2 == 0
                ? 'Antibiotics'
                : 'Vitamins',
        unitsSold: baseUnits,
        revenue: baseRevenue.toDouble(),
        growthRate: growthRate,
      );
    });

    // Generate mock sales by hour
    final salesByHour = List.generate(24, (hour) {
      final baseValue = 500.0;
      final timeOfDay = hour >= 9 && hour <= 17
          ? 2.0 // Business hours
          : hour >= 18 && hour <= 21
              ? 1.5 // Evening
              : 0.5; // Night
      final weekdayFactor = 1.0;
      return baseValue * timeOfDay * weekdayFactor +
          (hour % 3 == 0 ? 200 : 0).toDouble();
    });

    return SalesAnalytics(
      totalRevenue: salesTrend.fold<double>(
        0,
        (sum, point) => sum + point.revenue,
      ),
      totalSales: salesTrend.fold<int>(
        0,
        (sum, point) => sum + point.orders,
      ),
      averageOrderValue: salesTrend.fold<double>(
            0,
            (sum, point) => sum + point.revenue,
          ) /
          salesTrend.fold<int>(
            0,
            (sum, point) => sum + point.orders,
          ),
      growthRate: 15.0,
      salesGrowthRate: 12.0,
      orderValueGrowthRate: 3.0,
      conversionRate: 2.5,
      conversionRateGrowthRate: 0.5,
      salesTrend: salesTrend,
      topProducts: topProducts,
      salesByHour: salesByHour,
    );
  }
}
