// TODO: Implement controller logic for viewing stock items.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/inventory_service.dart';
import '../models/product_model.dart';

class ViewStockController extends GetxController {
  final InventoryService _inventoryService;
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;

  ViewStockController(this._inventoryService);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final allProducts = await _inventoryService.getAllProducts();
      products.value = allProducts;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      loadProducts();
      return;
    }

    isLoading.value = true;
    try {
      final searchResults = await _inventoryService.searchProducts(query);
      products.value = searchResults;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterByCategory(String category) async {
    selectedCategory.value = category;
    if (category.isEmpty || category == 'All') {
      loadProducts();
      return;
    }

    isLoading.value = true;
    try {
      final allProducts = await _inventoryService.getAllProducts();
      products.value = allProducts
          .where((product) => product.category == category)
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to filter products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editProduct(String id) async {
    final result = await Get.toNamed('/edit-stock', arguments: id);
    if (result == true) {
      loadProducts();
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
        products.removeWhere((product) => product.id == id);
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          colorText: Get.theme.colorScheme.onPrimaryContainer,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete product: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
        );
      }
    }
  }

  void refreshProducts() {
    loadProducts();
  }
}
