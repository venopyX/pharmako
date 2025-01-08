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

  ViewStockController(this._inventoryService);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
    loadManufacturers();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final products = await _inventoryService.getProducts();
      allProducts.value = products;
      applyFilters(); // This will update filteredProducts
    } catch (e) {
      AppLogger.error('Failed to load products: $e');
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
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
    } catch (e) {
      AppLogger.error('Failed to load categories: $e');
    }
  }

  Future<void> loadManufacturers() async {
    try {
      final loadedManufacturers = await _inventoryService.getManufacturers();
      manufacturers.value = ['All', ...loadedManufacturers];
    } catch (e) {
      AppLogger.error('Failed to load manufacturers: $e');
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
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
    var filtered = List<Product>.from(allProducts);

    // Apply search filter
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

    // Apply category filter
    if (selectedCategory.value.isNotEmpty && selectedCategory.value != 'All') {
      filtered = filtered.where((product) => 
        product.category == selectedCategory.value
      ).toList();
    }

    // Apply manufacturer filter
    if (selectedManufacturer.value.isNotEmpty && selectedManufacturer.value != 'All') {
      filtered = filtered.where((product) => 
        product.manufacturer == selectedManufacturer.value
      ).toList();
    }

    // Apply low stock filter
    if (showLowStock.value) {
      filtered = filtered.where((product) => 
        product.quantity <= product.minimumStockLevel
      ).toList();
    }

    // Apply expiring soon filter
    if (showExpiringSoon.value) {
      final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));
      filtered = filtered.where((product) => 
        product.expiryDate.isBefore(thirtyDaysFromNow)
      ).toList();
    }

    // Apply expiry date range filter
    if (expiryDateStart.value != null && expiryDateEnd.value != null) {
      filtered = filtered.where((product) =>
        product.expiryDate.isAfter(expiryDateStart.value!) &&
        product.expiryDate.isBefore(expiryDateEnd.value!.add(const Duration(days: 1)))
      ).toList();
    }

    // Apply sorting
    if (sortBy.value.isNotEmpty) {
      filtered.sort((a, b) {
        dynamic valueA = _getSortValue(a, sortBy.value);
        dynamic valueB = _getSortValue(b, sortBy.value);
        int comparison = valueA.compareTo(valueB);
        return sortAscending.value ? comparison : -comparison;
      });
    }

    filteredProducts.value = filtered;
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
    final start = currentPage.value * rowsPerPage.value;
    if (start >= filteredProducts.length) {
      currentPage.value = (filteredProducts.length - 1) ~/ rowsPerPage.value;
      return paginatedProducts;
    }
    final end = start + rowsPerPage.value;
    return filteredProducts.sublist(start, end > filteredProducts.length ? filteredProducts.length : end);
  }

  int get totalProducts => filteredProducts.length;

  void updatePagination(int? page, int? perPage) {
    if (perPage != null) {
      rowsPerPage.value = perPage;
      // Reset to first page when changing rows per page
      currentPage.value = 0;
    }
    if (page != null) {
      currentPage.value = page;
    }
  }

  Future<void> editProduct(Product product) async {
    final result = await Get.toNamed('/add-stock', arguments: product);
    if (result == true) {
      loadProducts();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _inventoryService.deleteProduct(id);
      loadProducts();
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      AppLogger.error('Failed to delete product: $e');
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Formatters
  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }

  // Refresh products
  Future<void> refreshProducts() async {
    try {
      isLoading.value = true;
      await loadProducts();
      AppLogger.info('Products refreshed successfully');
    } catch (e) {
      AppLogger.error('Error refreshing products: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
