import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing search functionality across the app
class SearchController extends GetxController {
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final searchResults = <dynamic>[].obs;
  final searchHistory = <String>[].obs;
  final selectedFilters = <String>[].obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadSearchHistory();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  /// Load search history from local storage
  Future<void> _loadSearchHistory() async {
    try {
      // TODO: Implement loading search history from local storage
      // This is a placeholder for demonstration
      searchHistory.value = [
        'Paracetamol',
        'Antibiotics',
        'First Aid',
        'Vitamins',
      ];
    } catch (e) {
      debugPrint('Error loading search history: $e');
    }
  }

  /// Perform search with the current query
  Future<void> search(String query) async {
    try {
      if (query.trim().isEmpty) {
        searchResults.clear();
        return;
      }

      searchQuery.value = query;
      isLoading.value = true;

      // TODO: Implement actual search functionality
      // This is a placeholder for demonstration
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Add to search history if not already present
      if (!searchHistory.contains(query)) {
        searchHistory.insert(0, query);
        if (searchHistory.length > 10) {
          searchHistory.removeLast();
        }
        // TODO: Save updated search history to local storage
      }

      // Simulate search results
      searchResults.value = [
        {'name': 'Product 1', 'category': 'Category A'},
        {'name': 'Product 2', 'category': 'Category B'},
        // Add more sample results as needed
      ];
    } catch (e) {
      debugPrint('Error performing search: $e');
      Get.snackbar(
        'Error',
        'Failed to perform search. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear the current search
  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    try {
      searchHistory.clear();
      // TODO: Clear search history from local storage
    } catch (e) {
      debugPrint('Error clearing search history: $e');
      Get.snackbar(
        'Error',
        'Failed to clear search history. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Toggle a search filter
  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    // Refresh search results with new filters
    if (searchQuery.isNotEmpty) {
      search(searchQuery.value);
    }
  }

  /// Clear all selected filters
  void clearFilters() {
    selectedFilters.clear();
    // Refresh search results without filters
    if (searchQuery.isNotEmpty) {
      search(searchQuery.value);
    }
  }
}
