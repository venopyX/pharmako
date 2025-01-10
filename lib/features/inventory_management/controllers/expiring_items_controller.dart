import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
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

  // Current time from system
  final DateTime currentTime = DateTime.now();

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

    // Filter by expiry status
    filtered = filtered.where((p) => 
      p.isExpiringSoonAt(currentTime) || p.isExpiredAt(currentTime)
    ).toList();

    filteredProducts.value = filtered;
    currentPage.value = 0; // Reset to first page when filters change
  }

  List<Product> get paginatedProducts {
    final startIndex = currentPage.value * rowsPerPage.value;
    final endIndex = (startIndex + rowsPerPage.value).clamp(0, filteredProducts.length);
    return filteredProducts.sublist(startIndex, endIndex);
  }

  int get totalProducts => filteredProducts.length;

  List<Product> get expiredItems => 
    allProducts.where((p) => p.isExpiredAt(currentTime)).toList();

  List<Product> get criticalItems =>
    allProducts.where((p) => p.isCriticalExpiryAt(currentTime)).toList();

  List<Product> get warningItems =>
    allProducts.where((p) => 
      p.isExpiringSoonAt(currentTime) && !p.isCriticalExpiryAt(currentTime)
    ).toList();

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
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int getDaysToExpiry(DateTime expiryDate) {
    return expiryDate.difference(currentTime).inDays;
  }

  String getExpiryStatus(Product product) {
    if (product.isExpiredAt(currentTime)) {
      return 'Expired';
    } else if (product.isCriticalExpiryAt(currentTime)) {
      return 'Critical';
    } else if (product.isExpiringSoonAt(currentTime)) {
      return 'Warning';
    }
    return 'Good';
  }
}
