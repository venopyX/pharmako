import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/sale_model.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../inventory_management/models/product_model.dart';
import '../../../utils/logging/logger.dart';

class SalesController extends GetxController {
  final InventoryRepository _inventoryRepository;
  final RxList<Product> products = <Product>[].obs;
  final RxList<SaleItem> cartItems = <SaleItem>[].obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxString searchQuery = ''.obs;
  final RxList<Product> filteredProducts = <Product>[].obs;

  SalesController(this._inventoryRepository);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    ever(searchQuery, (_) => filterProducts());
  }

  Future<void> loadProducts() async {
    try {
      final productsList = await _inventoryRepository.getAllProducts();
      products.value = productsList;
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
    if (quantity <= 0 || quantity > product.quantity) return;

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
  }

  void updateCartItemQuantity(SaleItem item, int quantity) {
    final product = products.firstWhere((p) => p.id == item.productId);
    if (quantity <= 0 || quantity > product.quantity) return;
    
    item.updateQuantity(quantity);
    _updateTotalAmount();
  }

  void removeFromCart(SaleItem item) {
    cartItems.remove(item);
    _updateTotalAmount();
  }

  void _updateTotalAmount() {
    totalAmount.value = cartItems.fold(
      0, 
      (sum, item) => sum + item.totalPrice.value
    );
  }

  Future<bool> completeSale() async {
    if (cartItems.isEmpty) return false;

    try {
      final sale = Sale(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        items: cartItems.toList(),
        totalAmount: totalAmount.value,
      );

      // Update inventory quantities
      for (var item in cartItems) {
        final product = products.firstWhere((p) => p.id == item.productId);
        final updatedProduct = product.copyWith(
          quantity: product.quantity - item.quantity.value,
        );
        await _inventoryRepository.updateProduct(updatedProduct);
      }

      // Clear cart after successful sale
      cartItems.clear();
      _updateTotalAmount();
      await loadProducts(); // Refresh products list
      return true;
    } catch (e) {
      AppLogger.error('Error completing sale: $e');
      return false;
    }
  }

  void clearCart() {
    cartItems.clear();
    _updateTotalAmount();
  }
}
