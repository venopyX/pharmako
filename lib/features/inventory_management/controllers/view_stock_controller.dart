import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/services/inventory_service.dart';
import '../../../utils/logging/logger.dart';
import '../models/product_model.dart';

class ViewStockController extends GetxController {
  final InventoryService _inventoryService;
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedManufacturer = ''.obs;
  final RxBool showLowStock = false.obs;
  final RxBool showExpiringSoon = false.obs;
  final Rx<DateTime?> expiryDateStart = Rx<DateTime?>(null);
  final Rx<DateTime?> expiryDateEnd = Rx<DateTime?>(null);
  final RxList<String> categories = <String>[].obs;
  final RxList<String> manufacturers = <String>[].obs;
  final RxString sortBy = ''.obs;
  final RxBool sortAscending = true.obs;

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
      _showError('Failed to load initial data', e);
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
      _showError('Failed to load categories', e);
    }
  }

  Future<void> loadManufacturers() async {
    try {
      final loadedManufacturers = await _inventoryService.getManufacturers();
      manufacturers.value = ['All', ...loadedManufacturers];
    } catch (e) {
      AppLogger.error('Failed to load manufacturers: $e');
      _showError('Failed to load manufacturers', e);
    }
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final filteredProducts = await _inventoryService.getProducts(
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
        manufacturer: selectedManufacturer.value == 'All' ? null : selectedManufacturer.value,
        lowStock: showLowStock.value ? true : null,
        expiringSoon: showExpiringSoon.value ? true : null,
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
      _showError('Failed to load products', e);
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
      case 'expiryDate':
        return product.expiryDate;
      case 'price':
        return product.price;
      default:
        return '';
    }
  }

  Future<void> updateSort(String field) async {
    if (sortBy.value == field) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortBy.value = field;
      sortAscending.value = true;
    }
    await loadProducts();
  }

  Future<void> updateFilters({
    String? category,
    String? manufacturer,
    bool? lowStock,
    bool? expiringSoon,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (category != null) selectedCategory.value = category;
    if (manufacturer != null) selectedManufacturer.value = manufacturer;
    if (lowStock != null) showLowStock.value = lowStock;
    if (expiringSoon != null) showExpiringSoon.value = expiringSoon;
    if (startDate != null) expiryDateStart.value = startDate;
    if (endDate != null) expiryDateEnd.value = endDate;
    await loadProducts();
  }

  Future<void> searchProducts(String query) async {
    searchQuery.value = query;
    await loadProducts();
  }

  Future<void> editProduct(String id) async {
    final result = await Get.toNamed('/edit-stock', arguments: id);
    if (result == true) {
      await loadProducts();
    }
  }

  Future<void> deleteProduct(String id) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _inventoryService.deleteProduct(id);
        await loadProducts();
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          colorText: Get.theme.colorScheme.onPrimaryContainer,
        );
      } catch (e) {
        AppLogger.error('Failed to delete product: $e');
        _showError('Failed to delete product', e);
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }

  String formatNumber(int number) {
    return NumberFormat('#,##0').format(number);
  }

  void _showError(String title, dynamic error) {
    Get.snackbar(
      title,
      error.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
      duration: const Duration(seconds: 5),
    );
  }

  void refreshProducts() {
    loadProducts();
  }
}
