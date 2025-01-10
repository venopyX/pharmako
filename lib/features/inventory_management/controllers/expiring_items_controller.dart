import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/services/inventory_service.dart';
import '../models/product_model.dart';

class ExpiringItemsController extends GetxController {
  final InventoryService _inventoryService;
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxInt currentPage = 0.obs;
  final RxInt rowsPerPage = 10.obs;
  final RxString sortColumn = ''.obs;
  final RxBool sortAscending = true.obs;

  ExpiringItemsController(this._inventoryService);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final products = await _inventoryService.getProducts();
      allProducts.value = products;
      categories.value = products.map((p) => p.category).toSet().toList()..sort();
      categories.insert(0, 'All');
      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void updateCategory(String? category) {
    selectedCategory.value = category ?? 'All';
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = allProducts.toList();

    // Apply category filter
    if (selectedCategory.value != 'All') {
      filtered = filtered.where((p) => p.category == selectedCategory.value).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((p) =>
          p.name.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query) ||
          p.manufacturer.toLowerCase().contains(query) ||
          p.batchNumber.toLowerCase().contains(query)
      ).toList();
    }

    // Filter by expiry status (only show items expiring within 90 days or already expired)
    filtered = filtered.where((p) {
      final now = DateTime.now();
      return p.isExpiringSoonAt(now) || p.isExpiredAt(now);
    }).toList();

    // Apply sorting
    if (sortColumn.value.isNotEmpty) {
      filtered.sort((a, b) {
        var comparison = 0;
        switch (sortColumn.value) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'category':
            comparison = a.category.compareTo(b.category);
            break;
          case 'expiryDate':
            comparison = a.expiryDate.compareTo(b.expiryDate);
            break;
          case 'daysToExpiry':
            final now = DateTime.now();
            final aDays = a.expiryDate.difference(now).inDays;
            final bDays = b.expiryDate.difference(now).inDays;
            comparison = aDays.compareTo(bDays);
            break;
        }
        return sortAscending.value ? comparison : -comparison;
      });
    }

    filteredProducts.value = filtered;
    currentPage.value = 0; // Reset to first page when filters change
  }

  void updateSort(String column) {
    if (sortColumn.value == column) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortColumn.value = column;
      sortAscending.value = true;
    }
    _applyFilters();
  }

  List<Product> get paginatedProducts {
    final startIndex = currentPage.value * rowsPerPage.value;
    final endIndex = (startIndex + rowsPerPage.value).clamp(0, filteredProducts.length);
    return filteredProducts.sublist(startIndex, endIndex);
  }

  int get totalProducts => filteredProducts.length;

  List<Product> get expiredItems {
    final now = DateTime.now();
    return allProducts.where((p) => p.isExpiredAt(now)).toList();
  }

  List<Product> get criticalItems {
    final now = DateTime.now();
    return allProducts.where((p) => p.isCriticalExpiryAt(now)).toList();
  }

  List<Product> get warningItems {
    final now = DateTime.now();
    return allProducts.where((p) => 
      p.isExpiringSoonAt(now) && !p.isCriticalExpiryAt(now)
    ).toList();
  }

  void updatePagination(int? perPage) {
    if (perPage != null && perPage > 0) {
      rowsPerPage.value = perPage;
      currentPage.value = 0; // Reset to first page
    }
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }

  int getDaysToExpiry(DateTime expiryDate) {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  String getExpiryStatus(Product product) {
    final now = DateTime.now();
    if (product.isExpiredAt(now)) {
      return 'Expired';
    } else if (product.isCriticalExpiryAt(now)) {
      return 'Critical';
    } else if (product.isExpiringSoonAt(now)) {
      return 'Warning';
    }
    return 'Good';
  }

  Color getExpiryStatusColor(Product product) {
    final now = DateTime.now();
    if (product.isExpiredAt(now)) {
      return Colors.red;
    } else if (product.isCriticalExpiryAt(now)) {
      return Colors.orange;
    } else if (product.isExpiringSoonAt(now)) {
      return Colors.amber;
    }
    return Colors.green;
  }

  IconData getExpiryStatusIcon(Product product) {
    final now = DateTime.now();
    if (product.isExpiredAt(now)) {
      return Icons.error;
    } else if (product.isCriticalExpiryAt(now)) {
      return Icons.warning;
    } else if (product.isExpiringSoonAt(now)) {
      return Icons.info;
    }
    return Icons.check_circle;
  }
}
