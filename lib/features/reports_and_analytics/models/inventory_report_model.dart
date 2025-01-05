import 'package:flutter/material.dart';

enum ReportType {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom
}

enum ReportFormat {
  pdf,
  excel,
  csv
}

class InventoryReport {
  final String id;
  final String title;
  final ReportType type;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime generatedAt;
  final List<InventoryReportItem> items;
  final InventoryReportSummary summary;

  const InventoryReport({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.generatedAt,
    required this.items,
    required this.summary,
  });

  factory InventoryReport.fromJson(Map<String, dynamic> json) {
    return InventoryReport(
      id: json['id'] as String,
      title: json['title'] as String,
      type: ReportType.values.firstWhere(
        (e) => e.toString() == 'ReportType.${json['type']}',
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => InventoryReportItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary:
          InventoryReportSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.toString().split('.').last,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'generatedAt': generatedAt.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
        'summary': summary.toJson(),
      };
}

class InventoryReportItem {
  final String productId;
  final String productName;
  final String category;
  final int openingStock;
  final int closingStock;
  final int stockReceived;
  final int stockSold;
  final int stockAdjusted;
  final double averagePrice;
  final double totalValue;
  final int minimumStockLevel;
  final DateTime? expiryDate;
  final String? batchNumber;
  final String? location;

  const InventoryReportItem({
    required this.productId,
    required this.productName,
    required this.category,
    required this.openingStock,
    required this.closingStock,
    required this.stockReceived,
    required this.stockSold,
    required this.stockAdjusted,
    required this.averagePrice,
    required this.totalValue,
    required this.minimumStockLevel,
    this.expiryDate,
    this.batchNumber,
    this.location,
  });

  factory InventoryReportItem.fromJson(Map<String, dynamic> json) {
    return InventoryReportItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String,
      openingStock: json['openingStock'] as int,
      closingStock: json['closingStock'] as int,
      stockReceived: json['stockReceived'] as int,
      stockSold: json['stockSold'] as int,
      stockAdjusted: json['stockAdjusted'] as int,
      averagePrice: json['averagePrice'] as double,
      totalValue: json['totalValue'] as double,
      minimumStockLevel: json['minimumStockLevel'] as int,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      batchNumber: json['batchNumber'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'category': category,
        'openingStock': openingStock,
        'closingStock': closingStock,
        'stockReceived': stockReceived,
        'stockSold': stockSold,
        'stockAdjusted': stockAdjusted,
        'averagePrice': averagePrice,
        'totalValue': totalValue,
        'minimumStockLevel': minimumStockLevel,
        if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
        if (batchNumber != null) 'batchNumber': batchNumber,
        if (location != null) 'location': location,
      };
}

class InventoryReportSummary {
  final int totalProducts;
  final int totalStockReceived;
  final int totalStockSold;
  final int totalStockAdjusted;
  final double totalInventoryValue;
  final double averageInventoryValue;
  final int lowStockItems;
  final int outOfStockItems;
  final int expiringItems;
  final Map<String, CategorySummary> categorySummary;

  const InventoryReportSummary({
    required this.totalProducts,
    required this.totalStockReceived,
    required this.totalStockSold,
    required this.totalStockAdjusted,
    required this.totalInventoryValue,
    required this.averageInventoryValue,
    required this.lowStockItems,
    required this.outOfStockItems,
    required this.expiringItems,
    required this.categorySummary,
  });

  factory InventoryReportSummary.fromJson(Map<String, dynamic> json) {
    return InventoryReportSummary(
      totalProducts: json['totalProducts'] as int,
      totalStockReceived: json['totalStockReceived'] as int,
      totalStockSold: json['totalStockSold'] as int,
      totalStockAdjusted: json['totalStockAdjusted'] as int,
      totalInventoryValue: json['totalInventoryValue'] as double,
      averageInventoryValue: json['averageInventoryValue'] as double,
      lowStockItems: json['lowStockItems'] as int,
      outOfStockItems: json['outOfStockItems'] as int,
      expiringItems: json['expiringItems'] as int,
      categorySummary: (json['categorySummary'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          CategorySummary.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalProducts': totalProducts,
        'totalStockReceived': totalStockReceived,
        'totalStockSold': totalStockSold,
        'totalStockAdjusted': totalStockAdjusted,
        'totalInventoryValue': totalInventoryValue,
        'averageInventoryValue': averageInventoryValue,
        'lowStockItems': lowStockItems,
        'outOfStockItems': outOfStockItems,
        'expiringItems': expiringItems,
        'categorySummary':
            categorySummary.map((key, value) => MapEntry(key, value.toJson())),
      };
}

class CategorySummary {
  final String name;
  final int productCount;
  final double totalValue;
  final double percentageOfTotal;
  final Color color;

  const CategorySummary({
    required this.name,
    required this.productCount,
    required this.totalValue,
    required this.percentageOfTotal,
    required this.color,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      name: json['name'] as String,
      productCount: json['productCount'] as int,
      totalValue: json['totalValue'] as double,
      percentageOfTotal: json['percentageOfTotal'] as double,
      color: Color(json['color'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'productCount': productCount,
        'totalValue': totalValue,
        'percentageOfTotal': percentageOfTotal,
        'color': color.value,
      };
}
