import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/sale_model.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/repositories/sales_repository.dart';
import '../../inventory_management/models/product_model.dart';
import '../../../utils/logging/logger.dart';

class SalesController extends GetxController {
  final InventoryRepository _inventoryRepository;
  final SalesRepository _salesRepository;
  final RxList<Product> products = <Product>[].obs;
  final RxList<SaleItem> cartItems = <SaleItem>[].obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxString searchQuery = ''.obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  
  // Map to track available quantities (considering cart items)
  final RxMap<String, int> availableQuantities = <String, int>{}.obs;

  SalesController(this._inventoryRepository, this._salesRepository);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    ever(searchQuery, (_) => filterProducts());
    ever(cartItems, (_) => _updateAvailableQuantities());
  }

  void _updateAvailableQuantities() {
    availableQuantities.clear();
    for (var product in products) {
      final cartItem = cartItems.firstWhereOrNull(
        (item) => item.productId == product.id
      );
      final inCartQuantity = cartItem?.quantity.value ?? 0;
      availableQuantities[product.id] = product.quantity - inCartQuantity;
    }
  }

  int getAvailableQuantity(String productId) {
    return availableQuantities[productId] ?? 0;
  }

  Future<void> loadProducts() async {
    try {
      final productsList = await _inventoryRepository.getAllProducts();
      products.value = productsList;
      _updateAvailableQuantities();
      filterProducts();
    } catch (e) {
      AppLogger.error('Error loading products: $e');
    }
  }

  void filterProducts() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products.where((product) =>
        product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        product.category.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
  }

  void addToCart(Product product, int quantity) {
    final availableQty = getAvailableQuantity(product.id);
    if (quantity <= 0 || quantity > availableQty) {
      Get.snackbar(
        'Invalid Quantity',
        'Cannot add more items than available in stock',
        backgroundColor: const Color(0xFFE57373),
        colorText: Colors.white,
      );
      return;
    }

    final existingItem = cartItems.firstWhereOrNull(
      (item) => item.productId == product.id
    );

    if (existingItem != null) {
      existingItem.updateQuantity(existingItem.quantity.value + quantity);
    } else {
      cartItems.add(SaleItem(
        productId: product.id,
        productName: product.name,
        unitPrice: product.price,
        quantity: quantity,
      ));
    }
    _updateTotalAmount();
    _updateAvailableQuantities();
  }

  void updateCartItemQuantity(SaleItem item, int quantity) {
    final product = products.firstWhere((p) => p.id == item.productId);
    final currentInCart = item.quantity.value;
    final availableForUpdate = product.quantity - currentInCart + currentInCart; // Add back current cart quantity

    if (quantity <= 0 || quantity > availableForUpdate) {
      Get.snackbar(
        'Invalid Quantity',
        'Cannot update to more items than available in stock',
        backgroundColor: const Color(0xFFE57373),
        colorText: Colors.white,
      );
      return;
    }
    
    item.updateQuantity(quantity);
    _updateTotalAmount();
    _updateAvailableQuantities();
  }

  void removeFromCart(SaleItem item) {
    cartItems.remove(item);
    _updateTotalAmount();
    _updateAvailableQuantities();
  }

  void _updateTotalAmount() {
    totalAmount.value = cartItems.fold(
      0, 
      (sum, item) => sum + item.totalPrice.value
    );
  }

  Future<bool> completeSale() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Cart is empty',
        backgroundColor: const Color(0xFFE57373),
        colorText: Colors.white,
      );
      return false;
    }

    try {
      // Verify stock availability before proceeding
      for (var item in cartItems) {
        final product = products.firstWhere(
          (p) => p.id == item.productId,
          orElse: () => throw Exception('Product not found: ${item.productId}'),
        );
        
        if (product.quantity < item.quantity.value) {
          Get.snackbar(
            'Error',
            'Insufficient stock for ${product.name}',
            backgroundColor: const Color(0xFFE57373),
            colorText: Colors.white,
          );
          return false;
        }
      }

      final sale = Sale(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        items: cartItems.toList(),
        totalAmount: totalAmount.value,
      );

      // Update inventory quantities and save sale
      for (var item in cartItems) {
        final product = products.firstWhere((p) => p.id == item.productId);
        final updatedProduct = product.copyWith(
          quantity: product.quantity - item.quantity.value,
        );
        await _inventoryRepository.updateProduct(updatedProduct);
      }
      
      // Save the sale record
      await _salesRepository.saveSale(sale);

      // Clear cart after successful sale
      cartItems.clear();
      _updateTotalAmount();
      await loadProducts(); // Refresh products list
      
      return true;
    } catch (e) {
      AppLogger.error('Error completing sale: $e');
      Get.snackbar(
        'Error',
        'Failed to complete sale: ${e.toString()}',
        backgroundColor: const Color(0xFFE57373),
        colorText: Colors.white,
      );
      return false;
    }
  }

  void clearCart() {
    cartItems.clear();
    _updateTotalAmount();
    _updateAvailableQuantities();
  }
}
