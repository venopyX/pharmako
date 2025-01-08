import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/services/inventory_service.dart';
import '../../../utils/logging/logger.dart';
import '../models/product_model.dart';

class ViewStockController extends GetxController {
  final InventoryService _inventoryService;
  
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedManufacturer = ''.obs;
  final RxBool showLowStock = false.obs;
  final RxBool showExpiringSoon = false.obs;
  final Rx<DateTime?> expiryDateStart = Rx<DateTime?>(null);
  final Rx<DateTime?> expiryDateEnd = Rx<DateTime?>(null);
  
  final RxList<String> categories = <String>[].obs;
  final RxList<String> manufacturers = <String>[].obs;
  
  final RxBool isLoading = false.obs;
  final RxString sortBy = ''.obs;
  final RxBool sortAscending = true.obs;
  final RxInt currentPage = 0.obs;
  final RxInt rowsPerPage = 10.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  ViewStockController(this._inventoryService);

  @override
  void onInit() {
    super.onInit();
    ever(rowsPerPage, (_) => validatePagination());
    ever(currentPage, (_) => validatePagination());
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      await Future.wait([
        loadProducts(),
        loadCategories(),
        loadManufacturers(),
      ]);
    } catch (e) {
      handleError('Failed to load initial data', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProducts() async {
    try {
      final products = await _inventoryService.getProducts();
      allProducts.value = products;
      applyFilters();
    } catch (e) {
      handleError('Failed to load products', e);
      rethrow;
    }
  }

  Future<void> loadCategories() async {
    try {
      final loadedCategories = await _inventoryService.getCategories();
      categories.value = ['All', ...loadedCategories];
    } catch (e) {
      handleError('Failed to load categories', e);
      rethrow;
    }
  }

  Future<void> loadManufacturers() async {
    try {
      final loadedManufacturers = await _inventoryService.getManufacturers();
      manufacturers.value = ['All', ...loadedManufacturers];
    } catch (e) {
      handleError('Failed to load manufacturers', e);
      rethrow;
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    currentPage.value = 0; // Reset to first page on search
    applyFilters();
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
    if (startDate != null || startDate == null) expiryDateStart.value = startDate;
    if (endDate != null || endDate == null) expiryDateEnd.value = endDate;
    
    currentPage.value = 0; // Reset to first page when filters change
    applyFilters();
  }

  void clearFilters() {
    selectedCategory.value = '';
    selectedManufacturer.value = '';
    showLowStock.value = false;
    showExpiringSoon.value = false;
    expiryDateStart.value = null;
    expiryDateEnd.value = null;
    searchQuery.value = '';
    currentPage.value = 0;
    applyFilters();
  }

  void updateSort(String field) {
    if (sortBy.value == field) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortBy.value = field;
      sortAscending.value = true;
    }
    applyFilters();
  }

  void applyFilters() {
    try {
      var filtered = List<Product>.from(allProducts);

      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        filtered = filtered.where((product) =>
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.manufacturer.toLowerCase().contains(query) ||
          product.batchNumber.toLowerCase().contains(query) ||
          product.location.toLowerCase().contains(query) ||
          product.quantity.toString().contains(query) ||
          product.price.toString().contains(query)
        ).toList();
      }

      if (selectedCategory.value.isNotEmpty && selectedCategory.value != 'All') {
        filtered = filtered.where((product) => 
          product.category == selectedCategory.value
        ).toList();
      }

      if (selectedManufacturer.value.isNotEmpty && selectedManufacturer.value != 'All') {
        filtered = filtered.where((product) => 
          product.manufacturer == selectedManufacturer.value
        ).toList();
      }

      if (showLowStock.value) {
        filtered = filtered.where((product) => 
          product.quantity <= product.minimumStockLevel
        ).toList();
      }

      if (showExpiringSoon.value) {
        final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));
        filtered = filtered.where((product) => 
          product.expiryDate.isBefore(thirtyDaysFromNow)
        ).toList();
      }

      if (expiryDateStart.value != null && expiryDateEnd.value != null) {
        filtered = filtered.where((product) =>
          product.expiryDate.isAfter(expiryDateStart.value!) &&
          product.expiryDate.isBefore(expiryDateEnd.value!.add(const Duration(days: 1)))
        ).toList();
      }

      if (sortBy.value.isNotEmpty) {
        filtered.sort((a, b) {
          dynamic valueA = _getSortValue(a, sortBy.value);
          dynamic valueB = _getSortValue(b, sortBy.value);
          int comparison = valueA.compareTo(valueB);
          return sortAscending.value ? comparison : -comparison;
        });
      }

      filteredProducts.value = filtered;
      // Reset to first page when filters change
      currentPage.value = 0;
      validatePagination();
      // Force UI update
      filteredProducts.refresh();
    } catch (e) {
      handleError('Error applying filters', e);
    }
  }

  void validatePagination() {
    if (filteredProducts.isEmpty) {
      currentPage.value = 0;
      return;
    }

    final maxPage = getMaxPage();
    if (currentPage.value > maxPage) {
      currentPage.value = maxPage;
    }
  }

  int getMaxPage() {
    return ((filteredProducts.length - 1) / rowsPerPage.value).floor().clamp(0, double.infinity).toInt();
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

  List<Product> get paginatedProducts {
    if (filteredProducts.isEmpty) return [];
    
    final maxPage = getMaxPage();
    if (currentPage.value > maxPage) {
      currentPage.value = maxPage;
      return [];
    }
    
    final start = currentPage.value * rowsPerPage.value;
    if (start >= filteredProducts.length) {
      currentPage.value = maxPage;
      return paginatedProducts; // Recursive call with corrected page
    }
    
    final end = (start + rowsPerPage.value).clamp(0, filteredProducts.length);
    return filteredProducts.sublist(start, end);
  }

  int get totalProducts => filteredProducts.length;

  void updatePagination(int? page, int? perPage) {
    try {
      if (perPage != null && perPage > 0) {
        rowsPerPage.value = perPage;
        // Reset to first page when changing rows per page to avoid invalid states
        currentPage.value = 0;
        filteredProducts.refresh();
      }
      
      if (page != null) {
        final maxPage = getMaxPage();
        final newPage = page.clamp(0, maxPage);
        if (currentPage.value != newPage) {
          currentPage.value = newPage;
          filteredProducts.refresh();
        }
      }
    } catch (e) {
      handleError('Error updating pagination', e);
    }
  }

  void handleError(String message, dynamic error) {
    hasError.value = true;
    errorMessage.value = message;
    AppLogger.error('$message: $error');
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
  }

  Future<void> refreshProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      await loadProducts();
      Get.snackbar(
        'Success',
        'Products refreshed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      handleError('Failed to refresh products', e);
    } finally {
      isLoading.value = false;
    }
  }
}