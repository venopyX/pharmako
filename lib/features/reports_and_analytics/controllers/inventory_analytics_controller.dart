import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/inventory_analytics_model.dart';
import '../../../data/services/analytics_service.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/constants/colors.dart';

class InventoryAnalyticsController extends GetxController {
  final AnalyticsService _analyticsService;
  final isLoading = false.obs;
  final analytics = InventoryAnalytics.empty().obs;
  final selectedPeriod = '30 Days'.obs;

  InventoryAnalyticsController(this._analyticsService);

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
        'Failed to load inventory analytics data',
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

  InventoryAnalytics _getMockData() {
    final now = DateTime.now();
    final daysInPeriod = selectedPeriod.value == '7 Days'
        ? 7
        : selectedPeriod.value == '30 Days'
            ? 30
            : 90;
    final startDate = now.subtract(Duration(days: daysInPeriod));

    // Generate mock value trend data
    final valueTrend = List.generate(daysInPeriod, (index) {
      final date = startDate.add(Duration(days: index));
      final baseValue = 100000.0 + (index * 1000);
      final variance = (index % 3 == 0 ? 5000.0 : 0.0) +
          (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday
              ? -2000.0
              : 0.0);
      return InventoryValuePoint(
        date: date,
        value: baseValue + variance,
      );
    });

    // Generate mock category distribution
    final categoryDistribution = [
      CategoryDistribution(
        category: 'Antibiotics',
        count: 150,
        percentage: 30,
        color: AppColors.blue,
      ),
      CategoryDistribution(
        category: 'Pain Relief',
        count: 100,
        percentage: 20,
        color: AppColors.red,
      ),
      CategoryDistribution(
        category: 'Vitamins',
        count: 75,
        percentage: 15,
        color: AppColors.green,
      ),
      CategoryDistribution(
        category: 'First Aid',
        count: 50,
        percentage: 10,
        color: AppColors.orange,
      ),
      CategoryDistribution(
        category: 'Others',
        count: 125,
        percentage: 25,
        color: AppColors.purple,
      ),
    ];

    // Generate mock low stock items
    final lowStockItems = List.generate(5, (index) {
      final stock = index == 0 ? 0 : index * 2;
      return LowStockItem(
        id: 'PROD${index + 1}',
        name: 'Product ${index + 1}',
        stock: stock,
        minimumStock: 10,
      );
    });

    // Generate mock expiring items
    final expiringItems = List.generate(10, (index) {
      final daysUntilExpiry = 15 + (index * 10);
      return ExpiringItem(
        id: 'PROD${index + 1}',
        name: 'Product ${index + 1}',
        batchNumber: 'BATCH${index + 1}',
        stock: 50 - (index * 3),
        expiryDate: now.add(Duration(days: daysUntilExpiry)),
        daysUntilExpiry: daysUntilExpiry,
      );
    });

    return InventoryAnalytics(
      totalProducts: categoryDistribution.fold(
        0,
        (sum, category) => sum + category.count,
      ),
      inventoryValue: valueTrend.last.value,
      lowStockCount: lowStockItems.length,
      outOfStockItems: lowStockItems.where((item) => item.stock <= 0).length,
      valueTrend: valueTrend,
      categoryDistribution: categoryDistribution,
      lowStockItems: lowStockItems,
      expiringItems: expiringItems,
    );
  }
}
