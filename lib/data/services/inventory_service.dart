import '../repositories/inventory_repository.dart';
import '../../features/inventory_management/models/product_model.dart';
import '../../utils/exceptions/exceptions.dart';
import '../../utils/logging/logger.dart';
import 'package:uuid/uuid.dart';

class InventoryService {
  final InventoryRepository _repository;
  final _uuid = const Uuid();

  InventoryService(this._repository);

  // Add new product
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final product = Product(
        id: _uuid.v4(),
        name: productData['name'],
        description: productData['description'],
        category: productData['category'],
        manufacturer: productData['manufacturer'],
        batchNumber: productData['batchNumber'],
        expiryDate: productData['expiryDate'],
        quantity: productData['quantity'],
        price: productData['price'],
        unit: productData['unit'],
        minimumStockLevel: productData['minimumStockLevel'],
        location: productData['location'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.addProduct(product);
      AppLogger.info('Product added successfully: ${product.name}');
    } catch (e) {
      AppLogger.error('Failed to add product: $e');
      throw InventoryException('Failed to add product: $e');
    }
  }

  // Get all products with filtering
  Future<List<Product>> getProducts({
    String? searchQuery,
    String? category,
    String? manufacturer,
    bool? lowStock,
    bool? expiringSoon,
    DateTime? expiryDateStart,
    DateTime? expiryDateEnd,
  }) async {
    try {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        return _repository.searchProducts(searchQuery);
      }
      
      return _repository.filterProducts(
        category: category,
        manufacturer: manufacturer,
        lowStock: lowStock,
        expiringSoon: expiringSoon,
        expiryDateStart: expiryDateStart,
        expiryDateEnd: expiryDateEnd,
      );
    } catch (e) {
      AppLogger.error('Failed to get products: $e');
      throw InventoryException('Failed to get products: $e');
    }
  }

  // Get product by ID
  Future<Product?> getProductById(String id) async {
    try {
      return _repository.getProductById(id);
    } catch (e) {
      AppLogger.error('Failed to get product by ID: $e');
      throw InventoryException('Failed to get product by ID: $e');
    }
  }

  // Update product
  Future<void> updateProduct(String id, Map<String, dynamic> productData) async {
    try {
      final existingProduct = await getProductById(id);
      if (existingProduct == null) {
        throw InventoryException('Product not found');
      }

      final updatedProduct = existingProduct.copyWith(
        name: productData['name'],
        description: productData['description'],
        category: productData['category'],
        manufacturer: productData['manufacturer'],
        batchNumber: productData['batchNumber'],
        expiryDate: productData['expiryDate'],
        quantity: productData['quantity'],
        price: productData['price'],
        unit: productData['unit'],
        minimumStockLevel: productData['minimumStockLevel'],
        location: productData['location'],
        updatedAt: DateTime.now(),
      );

      await _repository.updateProduct(updatedProduct);
      AppLogger.info('Product updated successfully: ${updatedProduct.name}');
    } catch (e) {
      AppLogger.error('Failed to update product: $e');
      throw InventoryException('Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      AppLogger.info('Product deleted successfully: $id');
    } catch (e) {
      AppLogger.error('Failed to delete product: $e');
      throw InventoryException('Failed to delete product: $e');
    }
  }

  // Update stock quantity
  Future<void> updateStock(String id, int quantity) async {
    try {
      await _repository.updateStock(id, quantity);
      AppLogger.info('Stock updated successfully for product: $id');
    } catch (e) {
      AppLogger.error('Failed to update stock: $e');
      throw InventoryException('Failed to update stock: $e');
    }
  }

  // Get low stock products
  Future<List<Product>> getLowStockProducts() async {
    try {
      return _repository.getLowStockProducts();
    } catch (e) {
      AppLogger.error('Failed to get low stock products: $e');
      throw InventoryException('Failed to get low stock products: $e');
    }
  }

  // Get expiring products
  Future<List<Product>> getExpiringSoonProducts() async {
    try {
      return _repository.getExpiringSoonProducts();
    } catch (e) {
      AppLogger.error('Failed to get expiring products: $e');
      throw InventoryException('Failed to get expiring products: $e');
    }
  }

  // Get categories
  Future<List<String>> getCategories() async {
    try {
      return _repository.getCategories();
    } catch (e) {
      AppLogger.error('Failed to get categories: $e');
      throw InventoryException('Failed to get categories: $e');
    }
  }

  // Get manufacturers
  Future<List<String>> getManufacturers() async {
    try {
      return _repository.getManufacturers();
    } catch (e) {
      AppLogger.error('Failed to get manufacturers: $e');
      throw InventoryException('Failed to get manufacturers: $e');
    }
  }

  // Generate barcode
  String _generateBarcode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _uuid.v4().substring(0, 4);
    return 'BAR${timestamp}${random}';
  }
}
