import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/customer_analytics_model.dart';
import '../../../data/services/analytics_service.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/constants/colors.dart';

class CustomerAnalyticsController extends GetxController {
  final AnalyticsService _analyticsService;
  final isLoading = false.obs;
  final analytics = CustomerAnalytics.empty().obs;
  final selectedPeriod = '30 Days'.obs;

  CustomerAnalyticsController(this._analyticsService);

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
        'Failed to load customer analytics data',
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

  String formatCurrencyCompact(double value) {
    return NumberFormat.compactCurrency(symbol: '\$').format(value);
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

  CustomerAnalytics _getMockData() {
    final now = DateTime.now();
    final daysInPeriod = selectedPeriod.value == '7 Days'
        ? 7
        : selectedPeriod.value == '30 Days'
            ? 30
            : 90;
    final startDate = now.subtract(Duration(days: daysInPeriod));

    // Generate mock customer trend data
    final customerTrend = List.generate(daysInPeriod, (index) {
      final date = startDate.add(Duration(days: index));
      final baseCount = 500 + (index * 2);
      final variance = (index % 3 == 0 ? 10 : 0) +
          (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday
              ? 5
              : 0);
      return CustomerTrendPoint(
        date: date,
        count: baseCount + variance,
      );
    });

    // Generate mock customer segments
    final segments = [
      CustomerSegment(
        name: 'Regular',
        count: 300,
        percentage: 60,
        averageValue: 500,
        color: AppColors.blue,
      ),
      CustomerSegment(
        name: 'Occasional',
        count: 150,
        percentage: 30,
        averageValue: 200,
        color: AppColors.green,
      ),
      CustomerSegment(
        name: 'New',
        count: 50,
        percentage: 10,
        averageValue: 100,
        color: AppColors.orange,
      ),
    ];

    // Generate mock top customers
    final topCustomers = List.generate(10, (index) {
      final segment = index < 5
          ? 'Regular'
          : index < 8
              ? 'Occasional'
              : 'New';
      final totalOrders = 50 - (index * 4);
      final totalValue = totalOrders * (100 + index * 10);
      return TopCustomer(
        id: 'CUST${index + 1}',
        name: 'Customer ${index + 1}',
        segment: segment,
        totalOrders: totalOrders,
        totalValue: totalValue.toDouble(),
        lastOrder: now.subtract(Duration(days: index * 2)),
      );
    });

    return CustomerAnalytics(
      totalCustomers: segments.fold(0, (sum, segment) => sum + segment.count),
      activeCustomers: segments
          .where((segment) => segment.name != 'New')
          .fold(0, (sum, segment) => sum + segment.count),
      averageCustomerValue: segments.fold<double>(
            0,
            (sum, segment) => sum + (segment.averageValue * segment.count),
          ) /
          segments.fold(0, (sum, segment) => sum + segment.count),
      customerGrowthRate: 15.0,
      activeCustomerRate: 85.0,
      retentionRate: 75.0,
      customerTrend: customerTrend,
      segments: segments,
      topCustomers: topCustomers,
    );
  }
}
