import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/sample_data_service.dart';
import '../models/inventory_item.dart';
import '../models/customer.dart';

/// Controller for managing reports and analytics
class ReportsManagementController extends GetxController {
  final _logger = Logger();

  // Observable states
  final isLoading = false.obs;
  final reportData = <String, dynamic>{}.obs;
  final dateRange = 'today'.obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // Sales Metrics
  final totalSales = 0.0.obs;
  final totalOrders = 0.obs;
  final averageOrderValue = 0.0.obs;
  final totalPrescriptions = 0.obs;
  final averagePrescriptionItems = 0.0.obs;

  // Inventory Metrics
  final totalInventoryItems = 0.obs;
  final totalStockValue = 0.0.obs;
  final lowStockItems = <InventoryItem>[].obs;
  final expiringItems = <InventoryItem>[].obs;

  // Customer Metrics
  final totalCustomers = 0.obs;
  final activeCustomers = 0.obs;
  final customerGrowth = 0.0.obs;
  final topCustomers = <Customer>[].obs;

  // Operational Metrics
  final averageProcessingTime = 0.0.obs;
  final staffEfficiency = 0.0.obs;
  final orderAccuracy = 0.0.obs;
  final returnRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReportData();
  }

  void _loadReportData() {
    try {
      isLoading.value = true;
      final data = SampleDataService.getReportData();
      reportData.value = data;

      // Update Sales Metrics
      totalSales.value = data['sales']['total'] ?? 0.0;
      totalOrders.value = data['sales']['orders'] ?? 0;
      averageOrderValue.value = data['sales']['average_order'] ?? 0.0;
      totalPrescriptions.value = data['sales']['prescriptions'] ?? 0;
      averagePrescriptionItems.value = data['sales']['average_prescription_items'] ?? 0.0;

      // Update Inventory Metrics
      totalInventoryItems.value = data['inventory']['total_items'] ?? 0;
      totalStockValue.value = data['inventory']['stock_value'] ?? 0.0;
      lowStockItems.value = (data['inventory']['low_stock'] as List? ?? [])
          .map((item) => InventoryItem.fromJson(item))
          .toList();
      expiringItems.value = (data['inventory']['expiring'] as List? ?? [])
          .map((item) => InventoryItem.fromJson(item))
          .toList();

      // Update Customer Metrics
      totalCustomers.value = data['customers']['total'] ?? 0;
      activeCustomers.value = data['customers']['active'] ?? 0;
      customerGrowth.value = data['customers']['growth'] ?? 0.0;
      topCustomers.value = (data['customers']['top'] as List? ?? [])
          .map((customer) => Customer.fromJson(customer))
          .toList();

      // Update Operational Metrics
      averageProcessingTime.value = data['operational']['processing_time'] ?? 0.0;
      staffEfficiency.value = data['operational']['efficiency'] ?? 0.0;
      orderAccuracy.value = data['operational']['accuracy'] ?? 0.0;
      returnRate.value = data['operational']['return_rate'] ?? 0.0;
    } catch (e, stackTrace) {
      _logger.e('Failed to load report data', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load report data',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Chart Methods
  LineChartData getProfitMarginChart() {
    // TODO: Implement actual chart data
    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 3),
            const FlSpot(1, 1),
            const FlSpot(2, 4),
            const FlSpot(3, 2),
          ],
          isCurved: true,
          color: Colors.blue,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  LineChartData getCustomerTrendsChart() {
    // TODO: Implement actual chart data
    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 2),
            const FlSpot(1, 3),
            const FlSpot(2, 2.5),
            const FlSpot(3, 4),
          ],
          isCurved: true,
          color: Colors.green,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  BarChartData getPeakHoursChart() {
    // TODO: Implement actual chart data
    return BarChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      barGroups: [
        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8)]),
        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10)]),
        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14)]),
        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15)]),
        BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13)]),
        BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 10)]),
      ],
    );
  }

  void updateDateRange(String range) {
    dateRange.value = range;
    _loadReportData();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    _loadReportData();
  }

  void setDateRange(String range) {
    dateRange.value = range;
    startDate.value = null;
    endDate.value = null;
    _loadReportData();
  }

  Future<void> exportReport() async {
    try {
      isLoading.value = true;
      // TODO: Implement report export functionality
      Get.snackbar(
        'Success',
        'Report exported successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to export report', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to export report',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods for data processing
  List<Map<String, dynamic>> getDailySalesTrend() {
    try {
      return List<Map<String, dynamic>>.from(
          reportData['salesTrends']['daily'] as List? ?? []);
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> getMonthlySalesTrend() {
    try {
      return List<Map<String, dynamic>>.from(
          reportData['salesTrends']['monthly'] as List? ?? []);
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> getInventoryMetrics() {
    try {
      return Map<String, dynamic>.from(reportData['inventoryMetrics'] ?? {});
    } catch (e) {
      return {};
    }
  }

  List<Map<String, dynamic>> getTopProducts() {
    try {
      final categoryData = reportData['categoryPerformance'] as List? ?? [];
      return List<Map<String, dynamic>>.from(categoryData)
        ..sort((a, b) => (b['sales'] as num).compareTo(a['sales'] as num));
    } catch (e) {
      return [];
    }
  }
}
