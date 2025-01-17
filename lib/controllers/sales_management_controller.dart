import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/inventory_item.dart';
import '../models/sale_item.dart';
import '../models/sale_transaction.dart';
import '../services/sample_data_service.dart';

/// Controller for managing sales operations and analytics
class SalesManagementController extends GetxController {
  final _logger = Logger();

  // Observable states
  final isLoading = false.obs;
  final filteredProducts = <InventoryItem>[].obs;
  final cartItems = <SaleItem>[].obs;
  final transactions = <SaleTransaction>[].obs;
  final salesStats = <String, dynamic>{}.obs;

  // Search and filter states
  final searchQuery = ''.obs;
  final transactionSearchQuery = ''.obs;
  final transactionFilter = 'all'.obs;

  // Checkout states
  final customerName = ''.obs;
  final paymentMethod = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    try {
      isLoading.value = true;
      
      // Load products
      final products = SampleDataService.getSampleItems();
      filteredProducts.value = products;

      // Load transactions
      transactions.value = SampleDataService.getSampleSales();

      // Load statistics
      salesStats.value = SampleDataService.getSalesStats();
    } catch (e, stackTrace) {
      _logger.e('Failed to load sample data', error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  // Product and cart operations
  void onSearchChanged(String query) {
    searchQuery.value = query;
    _filterProducts();
  }

  void _filterProducts() {
    if (searchQuery.isEmpty) {
      filteredProducts.value = SampleDataService.getSampleItems();
      return;
    }

    final query = searchQuery.toLowerCase();
    filteredProducts.value = SampleDataService.getSampleItems()
        .where((product) =>
            product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query))
        .toList();
  }

  void addToCart(InventoryItem product) {
    final existingIndex = cartItems
        .indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      increaseQuantity(existingIndex);
    } else {
      cartItems.add(SaleItem(
        product: product,
        quantity: 1,
        priceAtSale: product.price,
      ));
    }
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  void increaseQuantity(int index) {
    final item = cartItems[index];
    if (item.quantity < item.product.quantity) {
      cartItems[index] = SaleItem(
        product: item.product,
        quantity: item.quantity + 1,
        priceAtSale: item.priceAtSale,
      );
    } else {
      Get.snackbar(
        'Error',
        'Not enough stock available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void decreaseQuantity(int index) {
    final item = cartItems[index];
    if (item.quantity > 1) {
      cartItems[index] = SaleItem(
        product: item.product,
        quantity: item.quantity - 1,
        priceAtSale: item.priceAtSale,
      );
    } else {
      removeFromCart(index);
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  // Checkout operations
  void setCustomerName(String name) {
    customerName.value = name;
  }

  void setPaymentMethod(String? method) {
    if (method != null) {
      paymentMethod.value = method;
    }
  }

  Future<void> checkout() async {
    try {
      if (cartItems.isEmpty) {
        Get.snackbar(
          'Error',
          'Cart is empty',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (customerName.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter customer name',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (paymentMethod.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select payment method',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check if any item requires prescription
      final requiresPrescription = cartItems
          .any((item) => item.product.metadata?['prescription'] == true);

      if (requiresPrescription) {
        // TODO: Implement prescription validation
        _logger.i('Prescription validation required');
      }

      // Create new transaction
      final transaction = SaleTransaction(
        id: 'S${transactions.length + 1}'.padLeft(3, '0'),
        items: List.from(cartItems),
        customerName: customerName.value,
        transactionDate: DateTime.now(),
        paymentMethod: paymentMethod.value,
        status: 'Completed',
      );

      // Add to transactions
      transactions.add(transaction);

      // Clear cart and checkout states
      clearCart();
      customerName.value = '';
      paymentMethod.value = '';

      Get.snackbar(
        'Success',
        'Transaction completed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Checkout failed', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to complete transaction',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Transaction operations
  void onTransactionSearchChanged(String query) {
    transactionSearchQuery.value = query;
    _filterTransactions();
  }

  void setTransactionFilter(String filter) {
    transactionFilter.value = filter;
    _filterTransactions();
  }

  void _filterTransactions() {
    // TODO: Implement transaction filtering
  }

  // Computed properties
  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.total);
}
