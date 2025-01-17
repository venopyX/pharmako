import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';
import '../services/analytics_service.dart';
import '../services/export_service.dart';
import '../services/sample_data_service.dart';

/// Controller for managing inventory operations
class InventoryManagementController extends GetxController {
  final _logger = Logger();
  final _inventoryService = Get.find<InventoryService>();
  final _analyticsService = Get.find<AnalyticsService>();
  final _exportService = Get.find<ExportService>();

  // Controllers
  final searchController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isSearchMode = false.obs;
  final items = <InventoryItem>[].obs;
  final filteredItems = <InventoryItem>[].obs;
  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;
  final sortBy = ''.obs;
  final categories = <String>[].obs;

  // Statistics
  final totalItems = 0.obs;
  final lowStockCount = 0.obs;
  final expiringCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
    _setupListeners();
    searchController.addListener(() => onSearchChanged(searchController.text));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadSampleData() {
    try {
      isLoading.value = true;
      items.value = SampleDataService.getSampleItems();
      categories.value = SampleDataService.getCategories();
      _updateFilteredItems();
      _updateStatistics();
    } catch (e, stackTrace) {
      _logger.e('Failed to load sample data', error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  void _setupListeners() {
    ever(selectedCategory, (_) => _updateFilteredItems());
    ever(sortBy, (_) => _updateFilteredItems());
  }

  void _updateStatistics() {
    totalItems.value = items.length;
    lowStockCount.value = items.where((item) => 
      item.quantity < item.minQuantity
    ).length;
    expiringCount.value = items.where((item) => 
      item.isExpiringSoon
    ).length;
  }

  /// Toggle search mode
  void toggleSearchMode() {
    isSearchMode.value = !isSearchMode.value;
    if (!isSearchMode.value) {
      searchController.clear();
      onSearchChanged('');
    }
  }

  /// Toggle filter sheet
  void toggleFilterSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // TODO: Add filter options (categories, price range, stock status)
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  /// Handles search text changes and filters inventory items accordingly
  void onSearchChanged(String query) {
    searchQuery.value = query;
    _updateFilteredItems();
  }

  /// Update filtered items based on search and filters
  void _updateFilteredItems() {
    if (searchQuery.isEmpty && selectedCategory.isEmpty) {
      filteredItems.value = items;
      return;
    }

    filteredItems.value = items.where((item) {
      final matchesSearch = searchQuery.isEmpty ||
          item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory.isEmpty || item.category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();

    // Apply sorting
    if (sortBy.isNotEmpty) {
      filteredItems.sort((a, b) {
        switch (sortBy.value) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'quantity':
            return a.quantity.compareTo(b.quantity);
          case 'expiry':
            return a.expiryDate.compareTo(b.expiryDate);
          default:
            return 0;
        }
      });
    }
  }

  // Public methods
  Future<void> refreshInventory() async {
    _loadSampleData();
  }

  Future<void> addStock(InventoryItem item) async {
    try {
      await _inventoryService.addStock(item: item);
      await _analyticsService.trackOperation(
        operation: 'add_stock',
        itemId: item.id,
        details: {'quantity': item.quantity},
      );
      _loadSampleData();
      Get.back();
      Get.snackbar(
        'Success', 
        'Stock added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to add stock', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error', 
        'Failed to add stock. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeStock(String itemId, int quantity) async {
    try {
      await _inventoryService.removeStock(itemId: itemId, quantity: quantity);
      await _analyticsService.trackOperation(
        operation: 'remove_stock',
        itemId: itemId,
        details: {'quantity': quantity},
      );
      _loadSampleData();
      Get.back();
      Get.snackbar(
        'Success', 
        'Stock removed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to remove stock', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error', 
        'Failed to remove stock. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> adjustStock(String itemId, int newQuantity) async {
    try {
      await _inventoryService.adjustStock(itemId: itemId, newQuantity: newQuantity);
      await _analyticsService.trackOperation(
        operation: 'adjust_stock',
        itemId: itemId,
        details: {'new_quantity': newQuantity},
      );
      _loadSampleData();
      Get.back();
      Get.snackbar(
        'Success', 
        'Stock adjusted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to adjust stock', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error', 
        'Failed to adjust stock. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> exportInventory() async {
    try {
      final exportData = await _exportService.generateInventoryReport(items);
      await _exportService.exportToExcel(exportData);
      await _analyticsService.trackOperation(
        operation: 'export_inventory',
        itemId: 'all',
        details: {'total_items': items.length},
      );
      Get.snackbar(
        'Success', 
        'Inventory exported successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to export inventory', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error', 
        'Failed to export inventory. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
