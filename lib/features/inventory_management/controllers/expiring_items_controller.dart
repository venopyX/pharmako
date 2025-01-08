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
  final RxInt rowsPerPage = 10.obs;

  // Expiry thresholds
  static const int criticalThresholdDays = 30;
  static const int warningThresholdDays = 90;

  // Filtered lists for different expiry states
  List<Product> get expiredItems => filteredProducts
      .where((p) => p.expiryDate.isBefore(DateTime.now()))
      .toList();

  List<Product> get criticalItems => filteredProducts
      .where((p) => 
        !p.expiryDate.isBefore(DateTime.now()) &&
        p.expiryDate.difference(DateTime.now()).inDays <= criticalThresholdDays)
      .toList();

  List<Product> get warningItems => filteredProducts
      .where((p) {
        final daysToExpiry = p.expiryDate.difference(DateTime.now()).inDays;
        return !p.expiryDate.isBefore(DateTime.now()) &&
               daysToExpiry > criticalThresholdDays &&
               daysToExpiry <= warningThresholdDays;
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
      // Only keep products that are expired or will expire within warningThresholdDays
      final expiringProducts = products.where((p) {
        final daysToExpiry = p.expiryDate.difference(DateTime.now()).inDays;
        return p.expiryDate.isBefore(DateTime.now()) || daysToExpiry <= warningThresholdDays;
      }).toList();
      
      allProducts.assignAll(expiringProducts);
      categories.assignAll(expiringProducts.map((p) => p.category).toSet().toList()..sort());
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
    if (value != null) {
      rowsPerPage.value = value;
    }
  }

  void _applyFilters() {
    var filtered = List<Product>.from(allProducts);

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
  }

  void updateSort(String field) {
    switch (field) {
      case 'name':
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'category':
        filteredProducts.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'manufacturer':
        filteredProducts.sort((a, b) => a.manufacturer.compareTo(b.manufacturer));
        break;
      case 'expiryDate':
        filteredProducts.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
      case 'daysToExpiry':
        filteredProducts.sort((a, b) {
          final aDays = a.expiryDate.difference(DateTime.now()).inDays;
          final bDays = b.expiryDate.difference(DateTime.now()).inDays;
          return aDays.compareTo(bDays);
        });
        break;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String getDaysToExpiry(DateTime expiryDate) {
    final days = expiryDate.difference(DateTime.now()).inDays;
    if (days < 0) {
      return 'Expired ${-days} days ago';
    } else if (days == 0) {
      return 'Expires today';
    } else {
      return '$days days left';
    }
  }

  Color getExpiryColor(DateTime expiryDate) {
    final days = expiryDate.difference(DateTime.now()).inDays;
    if (days < 0) {
      return Colors.red;
    } else if (days <= criticalThresholdDays) {
      return Colors.orange;
    } else {
      return Colors.amber;
    }
  }
}
