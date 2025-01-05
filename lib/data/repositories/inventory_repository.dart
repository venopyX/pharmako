// TODO: Implement methods for managing inventory data, including adding, updating, and deleting stock items.

import '../../features/inventory_management/models/product_model.dart';

class InventoryRepository {
  // Simulated local storage for MVP
  final List<Product> _products = [];

  // Create
  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  // Read
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  Future<Product?> getProductById(String id) async {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> searchProducts(String query) async {
    query = query.toLowerCase();
    return _products.where((product) =>
        product.name.toLowerCase().contains(query) ||
        product.description.toLowerCase().contains(query) ||
        product.category.toLowerCase().contains(query) ||
        product.manufacturer.toLowerCase().contains(query) ||
        product.batchNumber.toLowerCase().contains(query)
    ).toList();
  }

  // Update
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  // Delete
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
  }

  // Stock Management
  Future<void> updateStock(String id, int quantity) async {
    final product = await getProductById(id);
    if (product != null) {
      final updatedProduct = product.copyWith(
        quantity: quantity,
        updatedAt: DateTime.now(),
      );
      await updateProduct(updatedProduct);
    }
  }

  // Low Stock Alerts
  Future<List<Product>> getLowStockProducts() async {
    return _products.where((product) => product.isLowStock).toList();
  }

  // Expiring Products
  Future<List<Product>> getExpiringSoonProducts() async {
    return _products.where((product) => product.isExpiringSoon).toList();
  }
}
