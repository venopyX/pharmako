import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../features/reports_and_analytics/models/dashboard_analytics_model.dart';
import '../../features/reports_and_analytics/models/inventory_report_model.dart';
import '../../utils/helpers/uuid_generator.dart';

class AnalyticsRepository extends GetxController {
  // Mock data for development
  DashboardAnalytics getMockDashboardAnalytics() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    // Generate mock sales trend data
    final salesTrend = List.generate(30, (index) {
      final date = thirtyDaysAgo.add(Duration(days: index));
      return SalesDataPoint(
        date: date,
        value: 1000 + (index * 50) + (index % 3 == 0 ? 200 : 0),
      );
    });

    // Generate mock customer trend data
    final customerTrend = List.generate(30, (index) {
      final date = thirtyDaysAgo.add(Duration(days: index));
      return SalesDataPoint(
        date: date,
        value: 50 + (index * 2) + (index % 5 == 0 ? 10 : 0),
      );
    });

    // Generate mock category distribution
    final categoryDistribution = [
      CategoryDistribution(
        category: 'Antibiotics',
        count: 150,
        percentage: 30,
        color: Colors.blue,
      ),
      CategoryDistribution(
        category: 'Pain Relief',
        count: 100,
        percentage: 20,
        color: Colors.red,
      ),
      CategoryDistribution(
        category: 'Vitamins',
        count: 75,
        percentage: 15,
        color: Colors.green,
      ),
      CategoryDistribution(
        category: 'First Aid',
        count: 50,
        percentage: 10,
        color: Colors.orange,
      ),
      CategoryDistribution(
        category: 'Others',
        count: 125,
        percentage: 25,
        color: Colors.purple,
      ),
    ];

    // Generate mock customer segments
    final customerSegments = [
      CustomerSegment(
        name: 'Regular',
        count: 300,
        percentage: 60,
        totalValue: 15000,
        color: Colors.blue,
      ),
      CustomerSegment(
        name: 'Occasional',
        count: 150,
        percentage: 30,
        totalValue: 5000,
        color: Colors.green,
      ),
      CustomerSegment(
        name: 'New',
        count: 50,
        percentage: 10,
        totalValue: 1000,
        color: Colors.orange,
      ),
    ];

    return DashboardAnalytics(
      sales: SalesAnalytics(
        totalRevenue: 50000,
        totalSales: 1000,
        averageOrderValue: 50,
        growthRate: 15,
        salesTrend: salesTrend,
      ),
      inventory: InventoryAnalytics(
        totalProducts: 500,
        lowStockItems: 25,
        outOfStockItems: 10,
        expiringItems: 15,
        inventoryValue: 100000,
        turnoverRate: 2.5,
        categoryDistribution: categoryDistribution,
      ),
      customers: CustomerAnalytics(
        totalCustomers: 500,
        customerGrowthRate: 10,
        averageCustomerValue: 100,
        segments: customerSegments,
        customerTrend: customerTrend,
      ),
      lastUpdated: now,
    );
  }

  InventoryReport getMockInventoryReport(
    ReportType type,
    DateTime startDate,
    DateTime endDate,
  ) {
    // Generate mock report items
    final items = List.generate(20, (index) {
      final isLowStock = index % 5 == 0;
      final isOutOfStock = index % 10 == 0;
      final isExpiring = index % 7 == 0;

      return InventoryReportItem(
        productId: 'PROD${index.toString().padLeft(3, '0')}',
        productName: 'Product $index',
        category: index % 5 == 0
            ? 'Antibiotics'
            : index % 4 == 0
                ? 'Pain Relief'
                : index % 3 == 0
                    ? 'Vitamins'
                    : index % 2 == 0
                        ? 'First Aid'
                        : 'Others',
        openingStock: 100 + index,
        closingStock: isOutOfStock ? 0 : isLowStock ? 5 : 80 + index,
        stockReceived: 50,
        stockSold: 70 + index,
        stockAdjusted: index % 3 == 0 ? 5 : 0,
        averagePrice: 10.0 + index,
        totalValue: (80 + index) * (10.0 + index),
        minimumStockLevel: 20,
        expiryDate: isExpiring
            ? DateTime.now().add(const Duration(days: 30))
            : DateTime.now().add(const Duration(days: 365)),
        batchNumber: 'BATCH${index.toString().padLeft(3, '0')}',
        location: 'Shelf ${(index % 5) + 1}',
      );
    });

    // Generate category summaries
    final categorySummary = {
      'Antibiotics': CategorySummary(
        name: 'Antibiotics',
        productCount: 4,
        totalValue: 25000,
        percentageOfTotal: 30,
        color: Colors.blue,
      ),
      'Pain Relief': CategorySummary(
        name: 'Pain Relief',
        productCount: 4,
        totalValue: 20000,
        percentageOfTotal: 20,
        color: Colors.red,
      ),
      'Vitamins': CategorySummary(
        name: 'Vitamins',
        productCount: 4,
        totalValue: 15000,
        percentageOfTotal: 15,
        color: Colors.green,
      ),
      'First Aid': CategorySummary(
        name: 'First Aid',
        productCount: 4,
        totalValue: 10000,
        percentageOfTotal: 10,
        color: Colors.orange,
      ),
      'Others': CategorySummary(
        name: 'Others',
        productCount: 4,
        totalValue: 25000,
        percentageOfTotal: 25,
        color: Colors.purple,
      ),
    };

    return InventoryReport(
      id: generateUuid(),
      title: '${type.toString().split('.').last.toUpperCase()} Inventory Report',
      type: type,
      startDate: startDate,
      endDate: endDate,
      generatedAt: DateTime.now(),
      items: items,
      summary: InventoryReportSummary(
        totalProducts: items.length,
        totalStockReceived: items.fold(0, (sum, item) => sum + item.stockReceived),
        totalStockSold: items.fold(0, (sum, item) => sum + item.stockSold),
        totalStockAdjusted:
            items.fold(0, (sum, item) => sum + item.stockAdjusted),
        totalInventoryValue:
            items.fold(0, (sum, item) => sum + item.totalValue),
        averageInventoryValue:
            items.fold(0, (sum, item) => sum + item.totalValue) / items.length,
        lowStockItems: items.where((item) => item.closingStock <= 5).length,
        outOfStockItems: items.where((item) => item.closingStock == 0).length,
        expiringItems: items
            .where((item) =>
                item.expiryDate != null &&
                item.expiryDate!
                    .difference(DateTime.now())
                    .inDays <= 30)
            .length,
        categorySummary: categorySummary,
      ),
    );
  }
}
