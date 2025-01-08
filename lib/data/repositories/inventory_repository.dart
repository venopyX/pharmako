import '../../features/inventory_management/models/product_model.dart';
import '../../utils/logging/logger.dart';

class InventoryRepository {
  // Simulated local storage for MVP
  final List<Product> _products = _generateSampleProducts();

  // Create
  Future<void> addProduct(Product product) async {
    _products.add(product);
    AppLogger.info('Product added: ${product.name}');
  }

  // Read
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  Future<Product?> getProductById(String id) async {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      AppLogger.warning('Product not found with ID: $id');
      return null;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return _products;
    
    query = query.toLowerCase();
    return _products.where((product) =>
        product.name.toLowerCase().contains(query) ||
        product.description.toLowerCase().contains(query) ||
        product.category.toLowerCase().contains(query) ||
        product.manufacturer.toLowerCase().contains(query) ||
        product.batchNumber.toLowerCase().contains(query) ||
        product.location.toLowerCase().contains(query) ||
        product.quantity.toString().contains(query) ||
        product.price.toString().contains(query)
    ).toList();
  }

  Future<List<String>> getCategories() async {
    return _products.map((p) => p.category).toSet().toList()..sort();
  }

  Future<List<String>> getManufacturers() async {
    return _products.map((p) => p.manufacturer).toSet().toList()..sort();
  }

  // Update
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      AppLogger.info('Product updated: ${product.name}');
    } else {
      AppLogger.warning('Product not found for update: ${product.id}');
    }
  }

  // Delete
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
    AppLogger.info('Product deleted: $id');
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
      AppLogger.info('Stock updated for product: ${product.name}');
    } else {
      AppLogger.error('Product not found for stock update: $id');
      throw Exception('Product not found');
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

  List<Product> filterProducts({
    String? category,
    String? manufacturer,
    bool? lowStock,
    bool? expiringSoon,
    DateTime? expiryDateStart,
    DateTime? expiryDateEnd,
  }) {
    return _products.where((product) {
      if (category != null && category != 'All' && product.category != category) return false;
      if (manufacturer != null && manufacturer != 'All' && product.manufacturer != manufacturer) return false;
      if (lowStock == true && !product.isLowStock) return false;
      if (expiringSoon == true && !product.isExpiringSoon) return false;
      if (expiryDateStart != null && product.expiryDate.isBefore(expiryDateStart)) return false;
      if (expiryDateEnd != null && product.expiryDate.isAfter(expiryDateEnd)) return false;
      return true;
    }).toList();
  }

  static List<Product> _generateSampleProducts() {
    final now = DateTime.now();
    return [
      Product(
        id: '1',
        name: 'Paracetamol 500mg',
        description: 'Pain relief and fever reducer',
        category: 'Pain Relief',
        price: 5.99,
        quantity: 1000,
        unit: 'tablets',
        manufacturer: 'PharmaCo',
        expiryDate: now.add(const Duration(days: 365)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 200,
        batchNumber: 'BATCH001',
        location: 'Shelf A1',
      ),
      Product(
        id: '2',
        name: 'Amoxicillin 250mg',
        description: 'Antibiotic medication',
        category: 'Antibiotics',
        price: 12.99,
        quantity: 150,
        unit: 'capsules',
        manufacturer: 'MediPharma',
        expiryDate: now.add(const Duration(days: 180)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 100,
        batchNumber: 'BATCH002',
        location: 'Shelf B2',
      ),
      Product(
        id: '3',
        name: 'Insulin Regular',
        description: 'Diabetes medication',
        category: 'Diabetes',
        price: 45.99,
        quantity: 50,
        unit: 'vials',
        manufacturer: 'DiabeCare',
        expiryDate: now.add(const Duration(days: 90)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 20,
        batchNumber: 'BATCH003',
        location: 'Refrigerator 1',
      ),
      Product(
        id: '4',
        name: 'Vitamin C 1000mg',
        description: 'Immune system support',
        category: 'Vitamins',
        price: 15.99,
        quantity: 500,
        unit: 'tablets',
        manufacturer: 'VitaHealth',
        expiryDate: now.add(const Duration(days: 730)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 100,
        batchNumber: 'BATCH004',
        location: 'Shelf C3',
      ),
      Product(
        id: '5',
        name: 'Ibuprofen 400mg',
        description: 'Anti-inflammatory medication',
        category: 'Pain Relief',
        price: 7.99,
        quantity: 80,
        unit: 'tablets',
        manufacturer: 'PharmaCo',
        expiryDate: now.add(const Duration(days: 45)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 100,
        batchNumber: 'BATCH005',
        location: 'Shelf A2',
      ),
      Product(
        id: '6',
        name: 'Aspirin 325mg',
        description: 'Pain relief and anti-inflammatory',
        category: 'Pain Relief',
        price: 4.99,
        quantity: 50,
        unit: 'tablets',
        manufacturer: 'PharmaCo',
        expiryDate: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 100,
        batchNumber: 'BATCH006',
        location: 'Shelf A3',
      ),
      Product(
        id: '7',
        name: 'Cetirizine 10mg',
        description: 'Allergy relief',
        category: 'Allergy',
        price: 8.99,
        quantity: 20,
        unit: 'tablets',
        manufacturer: 'AllergyCare',
        expiryDate: now.add(const Duration(days: 15)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 50,
        batchNumber: 'BATCH007',
        location: 'Shelf B1',
      ),
      Product(
        id: '8',
        name: 'Omeprazole 20mg',
        description: 'Heartburn relief',
        category: 'Gastrointestinal',
        price: 9.99,
        quantity: 10,
        unit: 'capsules',
        manufacturer: 'GastroPharma',
        expiryDate: now.subtract(const Duration(days: 5)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 30,
        batchNumber: 'BATCH008',
        location: 'Shelf C1',
      ),
      Product(
        id: '9',
        name: 'Loratadine 10mg',
        description: 'Allergy relief',
        category: 'Allergy',
        price: 6.99,
        quantity: 15,
        unit: 'tablets',
        manufacturer: 'AllergyCare',
        expiryDate: now.add(const Duration(days: 7)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 50,
        batchNumber: 'BATCH009',
        location: 'Shelf B2',
      ),
      Product(
        id: '10',
        name: 'Metformin 500mg',
        description: 'Diabetes medication',
        category: 'Diabetes',
        price: 10.99,
        quantity: 30,
        unit: 'tablets',
        manufacturer: 'DiabeCare',
        expiryDate: now.add(const Duration(days: 60)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 100,
        batchNumber: 'BATCH010',
        location: 'Shelf D1',
      ),
      Product(
        id: '11',
        name: 'Hydrocortisone Cream 1%',
        description: 'Skin irritation relief',
        category: 'Dermatology',
        price: 11.99,
        quantity: 5,
        unit: 'tubes',
        manufacturer: 'DermoPharma',
        expiryDate: now.add(const Duration(days: 20)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 20,
        batchNumber: 'BATCH011',
        location: 'Shelf E1',
      ),
      Product(
        id: '12',
        name: 'Multivitamin',
        description: 'Daily vitamin supplement',
        category: 'Vitamins',
        price: 14.99,
        quantity: 200,
        unit: 'tablets',
        manufacturer: 'VitaHealth',
        expiryDate: now.add(const Duration(days: 365)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 50,
        batchNumber: 'BATCH012',
        location: 'Shelf C4',
      ),
      Product(
        id: '13',
        name: 'Cough Syrup',
        description: 'Cough relief',
        category: 'Cough & Cold',
        price: 8.49,
        quantity: 10,
        unit: 'bottles',
        manufacturer: 'CoughCare',
        expiryDate: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 30,
        batchNumber: 'BATCH013',
        location: 'Shelf D2',
      ),
      Product(
        id: '14',
        name: 'Eye Drops',
        description: 'Eye irritation relief',
        category: 'Eye Care',
        price: 7.49,
        quantity: 5,
        unit: 'bottles',
        manufacturer: 'EyeCarePharma',
        expiryDate: now.add(const Duration(days: 5)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 15,
        batchNumber: 'BATCH014',
        location: 'Shelf E2',
      ),
      Product(
        id: '15',
        name: 'Antacid Tablets',
        description: 'Heartburn relief',
        category: 'Gastrointestinal',
        price: 5.99,
        quantity: 25,
        unit: 'tablets',
        manufacturer: 'GastroPharma',
        expiryDate: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
        minimumStockLevel: 50,
        batchNumber: 'BATCH015',
        location: 'Shelf C2',
      ),
    ];
  }
}
