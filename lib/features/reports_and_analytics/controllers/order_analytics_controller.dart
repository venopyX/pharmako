import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/order_analytics_model.dart';
import '../../../data/services/analytics_service.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/constants/colors.dart';

class OrderAnalyticsController extends GetxController {
  final AnalyticsService _analyticsService;
  final isLoading = false.obs;
  final analytics = OrderAnalytics.empty().obs;
  final selectedPeriod = '30 Days'.obs;

  OrderAnalyticsController(this._analyticsService);

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      // In a real app, we would fetch data from the service
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));
      analytics.value = _getMockData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load order analytics data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updatePeriod(String? period) {
    if (period != null) {
      selectedPeriod.value = period;
      refreshData();
    }
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(symbol: '\$').format(value);
  }

  String formatNumber(num value) {
    return NumberFormat.compact().format(value);
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
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

  OrderAnalytics _getMockData() {
    final now = DateTime.now();
    final daysInPeriod = selectedPeriod.value == '7 Days'
        ? 7
        : selectedPeriod.value == '30 Days'
            ? 30
            : 90;
    final startDate = now.subtract(Duration(days: daysInPeriod));

    // Generate mock order trend data
    final orderTrend = List.generate(daysInPeriod, (index) {
      final date = startDate.add(Duration(days: index));
      final baseCount = 50 + (index % 3 == 0 ? 10 : 0);
      final variance = (date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday)
          ? -10
          : 0;
      return OrderTrendPoint(
        date: date,
        count: baseCount + variance,
      );
    });

    // Generate mock order value distribution
    final valueDistribution = [
      OrderValueRange(range: '\$0-50', count: 150),
      OrderValueRange(range: '\$51-100', count: 300),
      OrderValueRange(range: '\$101-200', count: 200),
      OrderValueRange(range: '\$201-500', count: 100),
      OrderValueRange(range: '\$500+', count: 50),
    ];

    // Generate mock order status distribution
    final statusDistribution = [
      OrderStatusDistribution(
        name: 'Completed',
        count: 500,
        percentage: 60,
        color: AppColors.success,
      ),
      OrderStatusDistribution(
        name: 'Processing',
        count: 200,
        percentage: 24,
        color: AppColors.warning,
      ),
      OrderStatusDistribution(
        name: 'Pending',
        count: 100,
        percentage: 12,
        color: AppColors.info,
      ),
      OrderStatusDistribution(
        name: 'Cancelled',
        count: 30,
        percentage: 4,
        color: AppColors.error,
      ),
    ];

    // Generate mock recent orders
    final recentOrders = List.generate(10, (index) {
      final status = index < 5
          ? 'Completed'
          : index < 7
              ? 'Processing'
              : index < 9
                  ? 'Pending'
                  : 'Cancelled';
      final statusColor = status == 'Completed'
          ? AppColors.success
          : status == 'Processing'
              ? AppColors.warning
              : status == 'Pending'
                  ? AppColors.info
                  : AppColors.error;
      final itemCount = 1 + (index % 5);
      final totalValue = (50.0 + (index * 25)) * itemCount;
      return RecentOrder(
        id: 'ORD${1000 + index}',
        customerName: 'Customer ${index + 1}',
        itemCount: itemCount,
        totalValue: totalValue,
        status: status,
        statusColor: statusColor,
        date: now.subtract(Duration(hours: index * 4)),
      );
    });

    final totalOrders = orderTrend.fold(0, (sum, point) => sum + point.count);
    final totalValue = recentOrders.fold<double>(
        0, (sum, order) => sum + order.totalValue);

    return OrderAnalytics(
      totalOrders: totalOrders,
      averageOrderValue: totalValue / totalOrders,
      orderFrequency: (totalOrders / daysInPeriod).round(),
      orderGrowthRate: 15.0,
      completionRate: 85.0,
      orderTrend: orderTrend,
      valueDistribution: valueDistribution,
      statusDistribution: statusDistribution,
      recentOrders: recentOrders,
    );
  }
}
