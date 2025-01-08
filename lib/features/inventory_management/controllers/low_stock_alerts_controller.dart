import 'package:get/get.dart';
import '../../../data/services/inventory_service.dart';
import '../../../utils/logging/logger.dart';
import '../models/product_model.dart';

class LowStockAlertsController extends GetxController {
  final InventoryService _inventoryService;
  
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt rowsPerPage = 10.obs;
  final RxString sortColumn = ''.obs;
  final RxBool sortAscending = true.obs;

  LowStockAlertsController(this._inventoryService);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final products = await _inventoryService.getProducts();
      allProducts.value = products.where((p) => p.isLowStock).toList();
      applyFilters(); // This will update filteredProducts
    } catch (e) {
      AppLogger.error('Failed to load low stock products: $e');
      Get.snackbar(
        'Error',
        'Failed to load low stock products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final cats = await _inventoryService.getCategories();
      categories.value = cats;
    } catch (e) {
      AppLogger.error('Failed to load categories: $e');
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateCategory(String? category) {
    selectedCategory.value = category ?? '';
    applyFilters();
  }

  void applyFilters() {
    var filtered = List<Product>.from(allProducts);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((product) =>
        product.name.toLowerCase().contains(query) ||
        product.category.toLowerCase().contains(query) ||
        product.manufacturer.toLowerCase().contains(query)
      ).toList();
    }

    if (selectedCategory.isNotEmpty) {
      filtered = filtered.where((product) =>
        product.category == selectedCategory.value
      ).toList();
    }

    filteredProducts.value = filtered;
    _sortProducts();
  }

  void updateSort(String column) {
    if (sortColumn.value == column) {
      sortAscending.toggle();
    } else {
      sortColumn.value = column;
      sortAscending.value = true;
    }
    _sortProducts();
  }

  void _sortProducts() {
    if (sortColumn.isEmpty) return;

    filteredProducts.sort((a, b) {
      var comparison = 0;
      switch (sortColumn.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'category':
          comparison = a.category.compareTo(b.category);
          break;
        case 'manufacturer':
          comparison = a.manufacturer.compareTo(b.manufacturer);
          break;
        case 'quantity':
          comparison = a.quantity.compareTo(b.quantity);
          break;
        case 'minimumStockLevel':
          comparison = a.minimumStockLevel.compareTo(b.minimumStockLevel);
          break;
        case 'stockLevel':
          final levelA = (a.quantity / a.minimumStockLevel * 100);
          final levelB = (b.quantity / b.minimumStockLevel * 100);
          comparison = levelA.compareTo(levelB);
          break;
      }
      return sortAscending.value ? comparison : -comparison;
    });
  }

  void updatePagination(int? value) {
    if (value != null) {
      rowsPerPage.value = value;
    }
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  List<Product> get criticalItems => 
      filteredProducts.where((p) => p.quantity <= (p.minimumStockLevel * 0.25)).toList();

  List<Product> get needsReorderItems =>
      filteredProducts.where((p) => p.isLowStock).toList();

  void refreshData() {
    loadProducts();
    loadCategories();
  }
}
