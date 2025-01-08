import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/inventory_service.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart';

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

  // Fixed current time
  final DateTime currentTime = DateTime(2025, 1, 8);

  // Expiry thresholds
  static const int criticalThresholdDays = 30;
  static const int warningThresholdDays = 90;

  // Filtered lists for different expiry states
  List<Product> get expiredItems => allProducts
      .where((p) => p.isExpiredAt(currentTime))
      .toList();

  List<Product> get criticalItems => allProducts
      .where((p) => p.isExpiringSoonAt(currentTime))
      .toList();

  List<Product> get warningItems => allProducts
      .where((p) {
        final days = p.expiryDate.difference(currentTime).inDays;
        return days > criticalThresholdDays && days <= warningThresholdDays;
      })
      .toList();

  ExpiringItemsController(this._inventoryService);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final products = await _inventoryService.getProducts();
      allProducts.assignAll(products);
      categories.assignAll(products.map((p) => p.category).toSet().toList()..sort());
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

  void refreshData() {
    loadData();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void updateCategory(String? category) {
    selectedCategory.value = category ?? '';
    _applyFilters();
  }

  void updatePagination(int? value) {
    if (value != null && value > 0) {
      rowsPerPage.value = value;
      currentPage.value = 0;  // Reset to first page
      _applyFilters();
    }
  }

  void onPageChanged(int page) {
    if (page >= 0 && page * rowsPerPage.value < filteredProducts.length) {
      currentPage.value = page;
    }
  }

  List<Product> get paginatedProducts {
    if (filteredProducts.isEmpty) return [];
    
    final start = currentPage.value * rowsPerPage.value;
    if (start >= filteredProducts.length) {
      return [];
    }
    
    final end = start + rowsPerPage.value;
    if (end > filteredProducts.length) {
      return filteredProducts.sublist(start);
    }
    return filteredProducts.sublist(start, end);
  }

  int get totalProducts => filteredProducts.length;

  void _applyFilters() {
    var filtered = List<Product>.from(allProducts);

    // First filter by expiry status (expired, critical, or warning)
    filtered = filtered.where((p) {
      if (p.isExpiredAt(currentTime)) return true;
      final days = p.expiryDate.difference(currentTime).inDays;
      return days >= 0 && days <= warningThresholdDays;
    }).toList();

    // Apply category filter
    if (selectedCategory.isNotEmpty) {
      filtered = filtered.where((p) => p.category == selectedCategory.value).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((p) =>
        p.name.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query) ||
        p.manufacturer.toLowerCase().contains(query) ||
        p.batchNumber.toLowerCase().contains(query)
      ).toList();
    }

    // Sort by expiry date by default (closest to expiry first)
    filtered.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    filteredProducts.assignAll(filtered);
    // Reset to first page when filters change
    currentPage.value = 0;
  }

  void updateSort(String field) {
    var sorted = List<Product>.from(filteredProducts);
    
    switch (field) {
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'category':
        sorted.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'manufacturer':
        sorted.sort((a, b) => a.manufacturer.compareTo(b.manufacturer));
        break;
      case 'expiryDate':
        sorted.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
      case 'daysToExpiry':
        sorted.sort((a, b) {
          final aDays = a.expiryDate.difference(currentTime).inDays;
          final bDays = b.expiryDate.difference(currentTime).inDays;
          return aDays.compareTo(bDays);
        });
        break;
    }
    
    filteredProducts.assignAll(sorted);
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String getDaysToExpiry(DateTime expiryDate) {
    final days = expiryDate.difference(currentTime).inDays;
    if (days < 0) {
      return 'Expired ${-days} days ago';
    } else if (days == 0) {
      return 'Expires today';
    } else {
      return '$days days left';
    }
  }

  Color getExpiryColor(DateTime expiryDate) {
    final days = expiryDate.difference(currentTime).inDays;
    if (days < 0) {
      return Colors.red;
    } else if (days <= criticalThresholdDays) {
      return Colors.orange;
    } else {
      return Colors.amber;
    }
  }
}
