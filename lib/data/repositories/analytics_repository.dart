import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../features/reports_and_analytics/models/dashboard_analytics_model.dart';
import '../../features/reports_and_analytics/models/inventory_report_model.dart';

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

    // Generate mock inventory value trend
    final inventoryValueTrend = List.generate(30, (index) {
      final date = thirtyDaysAgo.add(Duration(days: index));
      return SalesDataPoint(
        date: date,
        value: 95000 + (index * 200),
      );
    });

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
        valueTrend: inventoryValueTrend,
      ),
      customers: CustomerAnalytics(
        totalCustomers: 500,
        customerGrowthRate: 8.5,
        averageCustomerValue: 75.0,
        segments: [
          CustomerSegment(
            name: 'Regular',
            count: 300,
            totalValue: 45000,
            percentage: 60,
            color: Colors.blue,
          ),
          CustomerSegment(
            name: 'Premium',
            count: 150,
            totalValue: 37500,
            percentage: 30,
            color: Colors.green,
          ),
          CustomerSegment(
            name: 'New',
            count: 50,
            totalValue: 5000,
            percentage: 10,
            color: Colors.orange,
          ),
        ],
        customerTrend: [
          SalesDataPoint(
            date: now.subtract(const Duration(days: 7)),
            value: 480,
          ),
          SalesDataPoint(
            date: now.subtract(const Duration(days: 6)),
            value: 485,
          ),
          SalesDataPoint(
            date: now.subtract(const Duration(days: 5)),
            value: 490,
          ),
          SalesDataPoint(
            date: now.subtract(const Duration(days: 4)),
            value: 492,
          ),
          SalesDataPoint(
            date: now.subtract(const Duration(days: 3)),
            value: 495,
          ),
          SalesDataPoint(
            date: now.subtract(const Duration(days: 2)),
            value: 498,
          ),
          SalesDataPoint(
            date: now.subtract(const Duration(days: 1)),
            value: 500,
          ),
        ],
      ),
      lastUpdated: now,
    );
  }

  // Sales Analytics
  Future<SalesAnalytics> getSalesAnalytics({
    required String period,
    required String metric,
  }) async {
    // TODO: Implement actual API call here
    // For now, return mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _getMockSalesAnalytics(period: period, metric: metric);
  }

  Future<SalesAnalytics> _getMockSalesAnalytics({
    required String period,
    required String metric,
  }) async {
    final now = DateTime.now();
    final daysInPeriod = period == '7 Days'
        ? 7
        : period == '30 Days'
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

      return SalesDataPoint(
        date: date,
        value: revenue,
      );
    });

    final totalRevenue = salesTrend.fold<double>(
      0,
      (sum, point) => sum + point.value,
    );

    final totalSales = salesTrend.fold<int>(
      0,
      (sum, point) => sum + (point.value / 50).round(),
    );

    return SalesAnalytics(
      totalRevenue: totalRevenue,
      totalSales: totalSales,
      averageOrderValue: totalRevenue / totalSales,
      growthRate: 15.0,
      salesTrend: salesTrend,
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'antibiotics':
        return Colors.blue;
      case 'pain relief':
        return Colors.red;
      case 'vitamins':
        return Colors.green;
      case 'first aid':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  InventoryReport getMockInventoryReport(ReportType type, DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final Map<String, CategorySummary> categorySummaries = {};
    final List<InventoryReportItem> tempItems = [];
    
    // First pass to create items
    for (int index = 0; index < 20; index++) {
      final category = index % 5 == 0 ? 'Antibiotics' : 
                      index % 4 == 0 ? 'Pain Relief' : 
                      index % 3 == 0 ? 'Vitamins' : 
                      index % 2 == 0 ? 'First Aid' : 'Others';

      final stockSold = 30 + index;
      final openingStock = 100 + index;
      final stockReceived = 50 + index;
      final closingStock = openingStock + stockReceived - stockSold;
      final unitPrice = 10.0 + index;
      final totalValue = closingStock * unitPrice;
      final stockAdjusted = 5;

      tempItems.add(
        InventoryReportItem(
          productId: 'PROD${index + 1}',
          productName: 'Product ${index + 1}',
          category: category,
          openingStock: openingStock,
          stockReceived: stockReceived,
          stockSold: stockSold,
          stockAdjusted: stockAdjusted,
          closingStock: closingStock,
          minimumStockLevel: 20,
          averagePrice: unitPrice,
          totalValue: totalValue,
          expiryDate: now.add(Duration(days: 90 + index)),
        ),
      );
    }

    // Second pass to calculate category summaries
    for (var item in tempItems) {
      final category = item.category;
      
      if (!categorySummaries.containsKey(category)) {
        categorySummaries[category] = CategorySummary(
          name: category,
          productCount: 0,
          totalValue: 0,
          percentageOfTotal: 0,
          color: _getCategoryColor(category),
        );
      }

      final currentSummary = categorySummaries[category]!;
      final newProductCount = currentSummary.productCount + item.closingStock;
      final newTotalValue = currentSummary.totalValue + item.totalValue;
      
      // Calculate total value of all items for percentage calculation
      double totalInventoryValue = tempItems.fold<double>(0, (sum, tempItem) => sum + tempItem.totalValue);
      if (totalInventoryValue == 0) totalInventoryValue = newTotalValue;
      
      categorySummaries[category] = CategorySummary(
        name: category,
        productCount: newProductCount,
        totalValue: newTotalValue,
        percentageOfTotal: (newTotalValue / totalInventoryValue) * 100,
        color: _getCategoryColor(category),
      );
    }

    final summary = InventoryReportSummary(
      totalProducts: tempItems.length,
      totalStockReceived: tempItems.fold<int>(0, (sum, item) => sum + item.stockReceived),
      totalStockSold: tempItems.fold<int>(0, (sum, item) => sum + item.stockSold),
      totalStockAdjusted: tempItems.fold<int>(0, (sum, item) => sum + item.stockAdjusted),
      totalInventoryValue: tempItems.fold<double>(0, (sum, item) => sum + item.totalValue),
      averageInventoryValue: tempItems.fold<double>(0, (sum, item) => sum + item.totalValue) / tempItems.length,
      lowStockItems: tempItems.where((item) => item.closingStock <= item.minimumStockLevel).length,
      outOfStockItems: tempItems.where((item) => item.closingStock == 0).length,
      expiringItems: tempItems.where((item) => item.expiryDate != null && item.expiryDate!.difference(now).inDays <= 30).length,
      categorySummary: categorySummaries,
    );

    return InventoryReport(
      id: 'REP-${now.millisecondsSinceEpoch}',
      title: '${type.name.toUpperCase()} Inventory Report',
      type: type,
      startDate: startDate,
      endDate: endDate,
      generatedAt: now,
      items: tempItems,
      summary: summary,
    );
  }
}
