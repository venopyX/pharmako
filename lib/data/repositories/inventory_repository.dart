// TODO: Implement methods for managing inventory data, including adding, updating, and deleting stock items.

import '../../features/inventory_management/models/product_model.dart';
import '../../utils/helpers/uuid_generator.dart';

class InventoryRepository {
  // Simulated local storage for MVP
  final List<Product> _products = _generateSampleProducts();

  // Create
  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  // Read
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  Future<Product?> getProductById(String id) async {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
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

  // Filter Products
  Future<List<Product>> filterProducts({
    String? category,
    String? manufacturer,
    bool? lowStock,
    bool? expiringSoon,
    DateTime? expiryDateStart,
    DateTime? expiryDateEnd,
  }) async {
    return _products.where((product) {
      if (category != null && product.category != category) return false;
      if (manufacturer != null && product.manufacturer != manufacturer) return false;
      if (lowStock != null && product.isLowStock != lowStock) return false;
      if (expiringSoon != null && product.isExpiringSoon != expiringSoon) return false;
      if (expiryDateStart != null && product.expiryDate.isBefore(expiryDateStart)) return false;
      if (expiryDateEnd != null && product.expiryDate.isAfter(expiryDateEnd)) return false;
      return true;
    }).toList();
  }

  // Get Categories
  Future<List<String>> getCategories() async {
    return _products.map((p) => p.category).toSet().toList()..sort();
  }

  // Get Manufacturers
  Future<List<String>> getManufacturers() async {
    return _products.map((p) => p.manufacturer).toSet().toList()..sort();
  }

  // Generate sample data
  static List<Product> _generateSampleProducts() {
    final categories = [
      'Antibiotics',
      'Painkillers',
      'Vitamins',
      'First Aid',
      'Chronic Care',
      'Diabetes Care',
      'Heart Care',
      'Respiratory Care'
    ];
    
    final manufacturers = [
      'PharmaCorp',
      'MediLabs',
      'HealthCare Inc',
      'BioTech Solutions',
      'Global Pharma'
    ];

    final locations = ['Shelf A', 'Shelf B', 'Shelf C', 'Cold Storage', 'Secure Cabinet'];

    final now = DateTime(2025, 1, 6); // Using the provided current time
    
    return List.generate(50, (index) {
      final category = categories[index % categories.length];
      final manufacturer = manufacturers[index % manufacturers.length];
      final location = locations[index % locations.length];
      final quantity = (index * 7 + 10) % 100;
      final unitPrice = (index * 2.5 + 5.99).roundToDouble();
      
      return Product(
        id: UuidGenerator.generate(),
        name: 'Product ${index + 1}',
        description: 'Description for Product ${index + 1}',
        category: category,
        manufacturer: manufacturer,
        batchNumber: 'BATCH${(index + 1).toString().padLeft(4, '0')}',
        expiryDate: now.add(Duration(days: 30 * (index % 24 + 1))),
        quantity: quantity,
        price: unitPrice,
        unit: 'units',
        minimumStockLevel: 20,
        location: location,
        createdAt: now.subtract(Duration(days: index * 2)),
        updatedAt: now.subtract(Duration(days: index)),
      );
    });
  }
}
