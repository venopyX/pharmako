// TODO: Implement business logic for inventory management, including stock level checks and updates.

import '../repositories/inventory_repository.dart';
import '../../features/inventory_management/models/product_model.dart';
import 'package:uuid/uuid.dart';

class InventoryService {
  final InventoryRepository _repository;
  final _uuid = const Uuid();

  InventoryService(this._repository);

  // Add new product
  Future<void> addProduct({
    required String name,
    required String description,
    required String category,
    required double price,
    required int quantity,
    required String unit,
    required String manufacturer,
    required DateTime expiryDate,
    required int minimumStockLevel,
    required String batchNumber,
    required String location,
  }) async {
    final product = Product(
      id: _uuid.v4(),
      name: name,
      description: description,
      category: category,
      price: price,
      quantity: quantity,
      unit: unit,
      manufacturer: manufacturer,
      expiryDate: expiryDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      minimumStockLevel: minimumStockLevel,
      batchNumber: batchNumber,
      location: location,
    );

    await _repository.addProduct(product);
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    return _repository.getAllProducts();
  }

  // Get product by ID
  Future<Product?> getProductById(String id) async {
    return _repository.getProductById(id);
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    return _repository.searchProducts(query);
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    await _repository.updateProduct(product.copyWith(
      updatedAt: DateTime.now(),
    ));
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    await _repository.deleteProduct(id);
  }

  // Update stock quantity
  Future<void> updateStock(String id, int quantity) async {
    await _repository.updateStock(id, quantity);
  }

  // Get low stock products
  Future<List<Product>> getLowStockProducts() async {
    return _repository.getLowStockProducts();
  }

  // Get expiring products
  Future<List<Product>> getExpiringSoonProducts() async {
    return _repository.getExpiringSoonProducts();
  }
}
