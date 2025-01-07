import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../../data/services/inventory_service.dart';
import '../../../utils/logging/logger.dart';
import '../models/product_model.dart';

class ViewStockController extends GetxController {
  final InventoryService _inventoryService;
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedManufacturer = 'All'.obs;
  final RxBool showLowStock = false.obs;
  final RxBool showExpiringSoon = false.obs;
  final Rx<DateTime?> expiryDateStart = Rx<DateTime?>(null);
  final Rx<DateTime?> expiryDateEnd = Rx<DateTime?>(null);
  final RxList<String> categories = <String>[].obs;
  final RxList<String> manufacturers = <String>[].obs;
  final RxString sortBy = ''.obs;
  final RxBool sortAscending = true.obs;
  final RxInt currentPage = 0.obs;
  final RxInt rowsPerPage = 10.obs;

  ViewStockController(this._inventoryService);

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadCategories(),
        loadManufacturers(),
        loadProducts(),
      ]);
    } catch (e) {
      AppLogger.error('Failed to load initial data: $e');
      Get.snackbar(
        'Error',
        'Failed to load initial data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final loadedCategories = await _inventoryService.getCategories();
      categories.value = ['All', ...loadedCategories];
      selectedCategory.value = 'All';
    } catch (e) {
      AppLogger.error('Failed to load categories: $e');
      rethrow;
    }
  }

  Future<void> loadManufacturers() async {
    try {
      final loadedManufacturers = await _inventoryService.getManufacturers();
      manufacturers.value = ['All', ...loadedManufacturers];
      selectedManufacturer.value = 'All';
    } catch (e) {
      AppLogger.error('Failed to load manufacturers: $e');
      rethrow;
    }
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final filteredProducts = await _inventoryService.getProducts(
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
        manufacturer: selectedManufacturer.value == 'All' ? null : selectedManufacturer.value,
        lowStock: showLowStock.value,
        expiringSoon: showExpiringSoon.value,
        expiryDateStart: expiryDateStart.value,
        expiryDateEnd: expiryDateEnd.value,
      );
      
      if (sortBy.value.isNotEmpty) {
        filteredProducts.sort((a, b) {
          dynamic valueA = _getSortValue(a, sortBy.value);
          dynamic valueB = _getSortValue(b, sortBy.value);
          int comparison = valueA.compareTo(valueB);
          return sortAscending.value ? comparison : -comparison;
        });
      }
      
      products.value = filteredProducts;
    } catch (e) {
      AppLogger.error('Failed to load products: $e');
      Get.snackbar(
        'Error',
        'Failed to load products',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  dynamic _getSortValue(Product product, String field) {
    switch (field) {
      case 'name':
        return product.name;
      case 'category':
        return product.category;
      case 'manufacturer':
        return product.manufacturer;
      case 'quantity':
        return product.quantity;
      case 'price':
        return product.price;
      case 'expiryDate':
        return product.expiryDate;
      default:
        return '';
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    loadProducts();
  }

  void updateFilters({
    String? category,
    String? manufacturer,
    bool? lowStock,
    bool? expiringSoon,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (category != null) selectedCategory.value = category;
    if (manufacturer != null) selectedManufacturer.value = manufacturer;
    if (lowStock != null) showLowStock.value = lowStock;
    if (expiringSoon != null) showExpiringSoon.value = expiringSoon;
    if (startDate != null) expiryDateStart.value = startDate;
    if (endDate != null) expiryDateEnd.value = endDate;
    loadProducts();
  }

  void updateSort(String field) {
    if (sortBy.value == field) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortBy.value = field;
      sortAscending.value = true;
    }
    loadProducts();
  }

  void refreshProducts() {
    loadProducts();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }

  void updatePagination(int? page, int? rowsPerPage) {
    if (page != null) currentPage.value = page;
    if (rowsPerPage != null) this.rowsPerPage.value = rowsPerPage;
  }

  List<Product> get paginatedProducts {
    final start = currentPage.value * rowsPerPage.value;
    final end = start + rowsPerPage.value;
    if (start >= products.length) return [];
    return products.sublist(start, end > products.length ? products.length : end);
  }

  int get totalProducts => products.length;
}
