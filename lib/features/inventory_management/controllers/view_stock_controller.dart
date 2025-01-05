// TODO: Implement controller logic for viewing stock items.

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
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterByCategory(String category) async {
    selectedCategory.value = category;
    if (category.isEmpty) {
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
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _inventoryService.deleteProduct(id);
      products.removeWhere((product) => product.id == id);
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}
