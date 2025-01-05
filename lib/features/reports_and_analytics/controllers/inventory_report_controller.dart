import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/services/analytics_service.dart';
import '../models/inventory_report_model.dart';

class InventoryReportController extends GetxController {
  final AnalyticsService _analyticsService;
  final Rx<InventoryReport?> report = Rx<InventoryReport?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedReportType = ReportType.monthly.toString().obs;
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString sortBy = 'productName'.obs;
  final RxBool sortAscending = true.obs;
  final RxList<String> selectedColumns = <String>[].obs;

  InventoryReportController(this._analyticsService);

  @override
  void onInit() {
    super.onInit();
    selectedColumns.value = [
      'productName',
      'category',
      'closingStock',
      'totalValue',
    ];
    generateReport();
  }

  Future<void> generateReport() async {
    isLoading.value = true;
    try {
      report.value = _analyticsService.generateInventoryReport(
        ReportType.values.firstWhere(
          (type) => type.toString() == selectedReportType.value,
        ),
        startDate.value,
        endDate.value,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate report: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateReportType(String type) {
    selectedReportType.value = type;
    generateReport();
  }

  void updateDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    generateReport();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSortBy(String field) {
    if (sortBy.value == field) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortBy.value = field;
      sortAscending.value = true;
    }
  }

  void toggleColumn(String column) {
    if (selectedColumns.contains(column)) {
      selectedColumns.remove(column);
    } else {
      selectedColumns.add(column);
    }
  }

  List<InventoryReportItem> get filteredItems {
    if (report.value == null) return [];

    var items = report.value!.items;

    // Apply category filter
    if (selectedCategory.value != 'All') {
      items = items.where((item) => item.category == selectedCategory.value).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      items = items.where((item) {
        return item.productName.toLowerCase().contains(query) ||
            item.productId.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    items.sort((a, b) {
      dynamic valueA;
      dynamic valueB;

      switch (sortBy.value) {
        case 'productName':
          valueA = a.productName;
          valueB = b.productName;
          break;
        case 'category':
          valueA = a.category;
          valueB = b.category;
          break;
        case 'closingStock':
          valueA = a.closingStock;
          valueB = b.closingStock;
          break;
        case 'totalValue':
          valueA = a.totalValue;
          valueB = b.totalValue;
          break;
        default:
          valueA = a.productName;
          valueB = b.productName;
      }

      int comparison;
      if (valueA is String) {
        comparison = valueA.compareTo(valueB);
      } else if (valueA is num) {
        comparison = valueA.compareTo(valueB);
      } else {
        comparison = 0;
      }

      return sortAscending.value ? comparison : -comparison;
    });

    return items;
  }

  List<String> get categories {
    if (report.value == null) return ['All'];
    final categories = report.value!.items
        .map((item) => item.category)
        .toSet()
        .toList()
      ..sort();
    return ['All', ...categories];
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  String formatNumber(num value) {
    return NumberFormat('#,##0').format(value);
  }

  String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  bool isColumnVisible(String column) {
    return selectedColumns.contains(column);
  }

  Future<void> exportReport(ReportFormat format) async {
    // TODO: Implement export functionality
    Get.snackbar(
      'Export',
      'Exporting report as ${format.toString().split('.').last}...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Map<String, dynamic> getReportMetrics() {
    if (report.value == null) return {};

    final summary = report.value!.summary;
    return {
      'Total Products': formatNumber(summary.totalProducts),
      'Total Value': formatCurrency(summary.totalInventoryValue),
      'Average Value': formatCurrency(summary.averageInventoryValue),
      'Low Stock Items': '${formatNumber(summary.lowStockItems)} items',
      'Out of Stock': '${formatNumber(summary.outOfStockItems)} items',
      'Expiring Soon': '${formatNumber(summary.expiringItems)} items',
    };
  }

  Map<String, double> getCategoryDistribution() {
    if (report.value == null) return {};

    return report.value!.summary.categorySummary.map(
          (key, value) => MapEntry(key, value.percentageOfTotal),
        );
  }
}
