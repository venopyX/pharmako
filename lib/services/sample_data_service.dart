import '../models/inventory_item.dart';
import '../models/sale_item.dart';
import '../models/sale_transaction.dart';
import '../models/notification.dart';
import '../models/user_profile.dart';
import '../models/activity_log.dart';

/// Service class providing sample data for the inventory management system
class SampleDataService {
  /// Get a list of sample inventory items
  static List<InventoryItem> getSampleItems() {
    return [
      InventoryItem(
        id: '1',
        name: 'Paracetamol 500mg',
        description: 'Pain reliever and fever reducer',
        category: 'Pain Relief',
        quantity: 150,
        minQuantity: 50,
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        price: 5.99,
        imageUrl: 'https://example.com/paracetamol.jpg',
        metadata: {
          'manufacturer': 'PharmaCo',
          'storage': 'Room temperature',
          'prescription': false,
        },
      ),
      InventoryItem(
        id: '2',
        name: 'Amoxicillin 250mg',
        description: 'Antibiotic for bacterial infections',
        category: 'Antibiotics',
        quantity: 30,
        minQuantity: 40,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        price: 12.99,
        imageUrl: 'https://example.com/amoxicillin.jpg',
        metadata: {
          'manufacturer': 'MediPharm',
          'storage': 'Cool and dry place',
          'prescription': true,
        },
      ),
      InventoryItem(
        id: '3',
        name: 'Vitamin C 1000mg',
        description: 'Immune system support supplement',
        category: 'Vitamins',
        quantity: 200,
        minQuantity: 100,
        expiryDate: DateTime.now().add(const Duration(days: 730)),
        price: 15.99,
        imageUrl: 'https://example.com/vitaminc.jpg',
        metadata: {
          'manufacturer': 'VitaCorp',
          'storage': 'Room temperature',
          'prescription': false,
        },
      ),
      InventoryItem(
        id: '4',
        name: 'Insulin Glargine',
        description: 'Long-acting insulin for diabetes',
        category: 'Diabetes',
        quantity: 25,
        minQuantity: 30,
        expiryDate: DateTime.now().add(const Duration(days: 20)),
        price: 89.99,
        imageUrl: 'https://example.com/insulin.jpg',
        metadata: {
          'manufacturer': 'DiabeCare',
          'storage': 'Refrigerated',
          'prescription': true,
        },
      ),
      InventoryItem(
        id: '5',
        name: 'Omeprazole 20mg',
        description: 'Acid reflux and heartburn relief',
        category: 'Digestive Health',
        quantity: 80,
        minQuantity: 40,
        expiryDate: DateTime.now().add(const Duration(days: 450)),
        price: 18.50,
        imageUrl: 'https://example.com/omeprazole.jpg',
        metadata: {
          'manufacturer': 'GastroHealth',
          'storage': 'Room temperature',
          'prescription': true,
        },
      ),
      InventoryItem(
        id: '6',
        name: 'First Aid Kit',
        description: 'Complete emergency first aid kit',
        category: 'Medical Supplies',
        quantity: 15,
        minQuantity: 10,
        expiryDate: DateTime.now().add(const Duration(days: 730)),
        price: 45.99,
        imageUrl: 'https://example.com/firstaid.jpg',
        metadata: {
          'manufacturer': 'SafetyFirst',
          'storage': 'Room temperature',
          'prescription': false,
        },
      ),
      InventoryItem(
        id: '7',
        name: 'Allergy Relief 10mg',
        description: 'Antihistamine for allergy relief',
        category: 'Allergy',
        quantity: 120,
        minQuantity: 60,
        expiryDate: DateTime.now().add(const Duration(days: 300)),
        price: 14.99,
        imageUrl: 'https://example.com/allergy.jpg',
        metadata: {
          'manufacturer': 'AllerCare',
          'storage': 'Room temperature',
          'prescription': false,
        },
      ),
      InventoryItem(
        id: '8',
        name: 'Blood Pressure Monitor',
        description: 'Digital blood pressure monitoring device',
        category: 'Medical Devices',
        quantity: 8,
        minQuantity: 5,
        expiryDate: DateTime.now().add(const Duration(days: 1825)),
        price: 79.99,
        imageUrl: 'https://example.com/bpmonitor.jpg',
        metadata: {
          'manufacturer': 'HealthTech',
          'storage': 'Room temperature',
          'prescription': false,
          'warranty': '2 years',
        },
      ),
      InventoryItem(
        id: '9',
        name: 'Aspirin 81mg',
        description: 'Low-dose aspirin for heart health',
        category: 'Heart Health',
        quantity: 250,
        minQuantity: 100,
        expiryDate: DateTime.now().add(const Duration(days: 15)),
        price: 8.99,
        imageUrl: 'https://example.com/aspirin.jpg',
        metadata: {
          'manufacturer': 'HeartCare',
          'storage': 'Room temperature',
          'prescription': false,
        },
      ),
      InventoryItem(
        id: '10',
        name: 'Hand Sanitizer',
        description: '70% alcohol hand sanitizer',
        category: 'Personal Care',
        quantity: 45,
        minQuantity: 50,
        expiryDate: DateTime.now().add(const Duration(days: 545)),
        price: 4.99,
        imageUrl: 'https://example.com/sanitizer.jpg',
        metadata: {
          'manufacturer': 'CleanCo',
          'storage': 'Room temperature',
          'prescription': false,
          'volume': '500ml',
        },
      ),
    ];
  }

  /// Get a list of available categories
  static List<String> getCategories() {
    return [
      'Pain Relief',
      'Antibiotics',
      'Vitamins',
      'Diabetes',
      'Digestive Health',
      'Medical Supplies',
      'Allergy',
      'Medical Devices',
      'Heart Health',
      'Personal Care',
    ];
  }

  /// Get a list of sample sales transactions
  static List<SaleTransaction> getSampleSales() {
    return [
      SaleTransaction(
        id: 'S001',
        items: [
          SaleItem(
            product: getSampleItems()[0],
            quantity: 2,
            priceAtSale: 5.99,
          ),
          SaleItem(
            product: getSampleItems()[2],
            quantity: 1,
            priceAtSale: 15.99,
          ),
        ],
        customerName: 'John Doe',
        transactionDate: DateTime.now().subtract(const Duration(hours: 2)),
        paymentMethod: 'Credit Card',
        status: 'Completed',
      ),
      SaleTransaction(
        id: 'S002',
        items: [
          SaleItem(
            product: getSampleItems()[3],
            quantity: 1,
            priceAtSale: 89.99,
          ),
        ],
        customerName: 'Jane Smith',
        transactionDate: DateTime.now().subtract(const Duration(hours: 4)),
        paymentMethod: 'Cash',
        status: 'Completed',
        prescriptionId: 'RX123',
      ),
      // Add more sample transactions...
    ];
  }

  /// Get sample sales statistics
  static Map<String, dynamic> getSalesStats() {
    return {
      'todaySales': 2150.75,
      'weekSales': 15780.50,
      'monthSales': 64250.25,
      'popularItems': [
        {'name': 'Paracetamol 500mg', 'count': 145},
        {'name': 'Vitamin C 1000mg', 'count': 98},
        {'name': 'First Aid Kit', 'count': 45},
      ],
      'paymentMethods': {
        'Cash': 35,
        'Credit Card': 45,
        'Insurance': 20,
      },
    };
  }

  /// Get comprehensive report data
  static Map<String, dynamic> getReportData() {
    return {
      'overview': {
        'totalRevenue': 125750.50,
        'totalOrders': 1250,
        'averageOrderValue': 100.60,
        'totalCustomers': 850,
      },
      'inventoryMetrics': {
        'totalItems': 2500,
        'lowStockItems': 15,
        'expiringItems': 8,
        'outOfStockItems': 3,
        'inventoryValue': 75000.00,
      },
      'salesTrends': {
        'daily': [
          {'date': '2025-01-16', 'sales': 2150.75},
          {'date': '2025-01-15', 'sales': 1890.50},
          {'date': '2025-01-14', 'sales': 2450.25},
          {'date': '2025-01-13', 'sales': 1950.00},
          {'date': '2025-01-12', 'sales': 2250.75},
          {'date': '2025-01-11', 'sales': 1750.50},
          {'date': '2025-01-10', 'sales': 2050.25},
        ],
        'monthly': [
          {'month': 'Jan', 'sales': 64250.25},
          {'month': 'Dec', 'sales': 58750.50},
          {'month': 'Nov', 'sales': 52150.75},
          {'month': 'Oct', 'sales': 48950.00},
          {'month': 'Sep', 'sales': 51250.25},
          {'month': 'Aug', 'sales': 49750.50},
        ],
      },
      'categoryPerformance': [
        {'category': 'Pain Relief', 'sales': 25150.75, 'quantity': 2150},
        {'category': 'Antibiotics', 'sales': 18950.50, 'quantity': 950},
        {'category': 'Vitamins', 'sales': 15750.25, 'quantity': 1580},
        {'category': 'First Aid', 'sales': 12550.00, 'quantity': 450},
        {'category': 'Personal Care', 'sales': 9850.75, 'quantity': 780},
      ],
      'profitMargins': {
        'overall': 0.35,
        'byCategory': {
          'Pain Relief': 0.40,
          'Antibiotics': 0.35,
          'Vitamins': 0.45,
          'First Aid': 0.30,
          'Personal Care': 0.38,
        },
      },
      'customerMetrics': {
        'newCustomers': 125,
        'returningCustomers': 725,
        'averageVisitFrequency': 2.5,
        'topCustomers': [
          {'name': 'John Doe', 'totalPurchases': 3850.75, 'visits': 12},
          {'name': 'Jane Smith', 'totalPurchases': 2950.50, 'visits': 8},
          {'name': 'Bob Johnson', 'totalPurchases': 2750.25, 'visits': 7},
        ],
      },
      'prescriptionStats': {
        'totalPrescriptions': 450,
        'averageValue': 125.50,
        'insuranceClaims': 280,
        'popularDoctors': [
          {'name': 'Dr. Smith', 'prescriptions': 85},
          {'name': 'Dr. Johnson', 'prescriptions': 65},
          {'name': 'Dr. Williams', 'prescriptions': 45},
        ],
      },
      'operationalMetrics': {
        'averageProcessingTime': 8.5,
        'peakHours': [
          {'hour': '9-10', 'transactions': 45},
          {'hour': '12-13', 'transactions': 65},
          {'hour': '17-18', 'transactions': 55},
        ],
        'stockTurnover': 4.2,
        'returnRate': 0.02,
      },
    };
  }

  /// Get sample notifications for testing
  static List<Notification> getSampleNotifications() {
    return [
      Notification(
        id: '1',
        title: 'Low Stock Alert',
        message: 'Paracetamol stock is running low. Current quantity: 50 units',
        type: 'inventory',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        priority: 'high',
        metadata: {
          'item': 'Paracetamol',
          'quantity': 50,
          'threshold': 100,
        },
        actionRoute: '/inventory',
      ),
      Notification(
        id: '2',
        title: 'New Sale Completed',
        message: 'Sale #1234 completed successfully',
        type: 'sales',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        priority: 'normal',
        metadata: {
          'saleId': '1234',
          'amount': 156.50,
          'items': 3,
        },
        actionRoute: '/sales/1234',
      ),
      Notification(
        id: '3',
        title: 'System Update Available',
        message: 'A new system update is available. Please update at your earliest convenience.',
        type: 'system',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        priority: 'normal',
      ),
      Notification(
        id: '4',
        title: 'Monthly Sales Report',
        message: 'The monthly sales report for December 2024 is now available',
        type: 'reports',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        priority: 'normal',
        actionRoute: '/reports/monthly',
      ),
      Notification(
        id: '5',
        title: 'Expiring Items Alert',
        message: '15 items will expire within the next 30 days',
        type: 'inventory',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        priority: 'high',
        metadata: {
          'count': 15,
          'daysUntilExpiry': 30,
        },
        actionRoute: '/inventory/expiring',
      ),
    ];
  }

  /// Get sample user profiles
  static List<UserProfile> getSampleUserProfiles() {
    return [
      UserProfile(
        id: 'U001',
        name: 'John Doe',
        email: 'john.doe@example.com',
        role: 'admin',
        photoUrl: 'https://i.pravatar.cc/150?u=john.doe',
        preferences: {
          'theme': 'dark',
          'language': 'en',
          'timezone': 'UTC+3',
          'currency': 'USD',
          'dateFormat': 'MM/dd/yyyy',
          'timeFormat': '24h',
          'notifications': {
            'email': true,
            'push': true,
            'sms': true,
          },
          'display': {
            'compactMode': false,
            'highContrast': false,
            'fontSize': 'medium',
            'animations': true,
          },
        },
        permissions: {
          'inventory.view': true,
          'inventory.edit': true,
          'sales.view': true,
          'sales.edit': true,
          'reports.view': true,
          'reports.edit': true,
          'users.view': true,
          'users.edit': true,
          'settings.view': true,
          'settings.edit': true,
        },
        lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      UserProfile(
        id: 'U002',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        role: 'pharmacist',
        photoUrl: 'https://i.pravatar.cc/150?u=jane.smith',
        preferences: {
          'theme': 'light',
          'language': 'en',
          'timezone': 'UTC+3',
          'currency': 'USD',
          'dateFormat': 'dd/MM/yyyy',
          'timeFormat': '12h',
          'notifications': {
            'email': true,
            'push': true,
            'sms': false,
          },
          'display': {
            'compactMode': true,
            'highContrast': false,
            'fontSize': 'large',
            'animations': true,
          },
        },
        permissions: {
          'inventory.view': true,
          'inventory.edit': true,
          'sales.view': true,
          'sales.edit': true,
          'reports.view': true,
          'reports.edit': false,
          'users.view': false,
          'users.edit': false,
          'settings.view': true,
          'settings.edit': false,
        },
        lastLogin: DateTime.now().subtract(const Duration(hours: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
      ),
      UserProfile(
        id: 'U003',
        name: 'Bob Wilson',
        email: 'bob.wilson@example.com',
        role: 'cashier',
        photoUrl: 'https://i.pravatar.cc/150?u=bob.wilson',
        preferences: UserProfile.defaultPreferences,
        permissions: {
          'inventory.view': true,
          'inventory.edit': false,
          'sales.view': true,
          'sales.edit': true,
          'reports.view': false,
          'reports.edit': false,
          'users.view': false,
          'users.edit': false,
          'settings.view': true,
          'settings.edit': false,
        },
        lastLogin: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }

  /// Get current user profile
  static UserProfile getCurrentUserProfile() {
    return getSampleUserProfiles().first;
  }

  /// Get sample activity logs for testing
  static List<ActivityLog> getSampleActivityLogs() {
    return [
      ActivityLog(
        id: '1',
        userId: 'U001',
        userName: 'John Doe',
        action: 'create',
        module: 'inventory',
        description: 'Added new product: Paracetamol 500mg',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        details: {
          'productId': 'P001',
          'name': 'Paracetamol 500mg',
          'quantity': 100,
          'price': 9.99,
        },
        status: 'success',
      ),
      ActivityLog(
        id: '2',
        userId: 'U002',
        userName: 'Jane Smith',
        action: 'update',
        module: 'sales',
        description: 'Updated sale transaction #1234',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        details: {
          'saleId': '1234',
          'amount': 156.50,
          'items': 3,
          'customer': 'Alice Johnson',
        },
        status: 'success',
      ),
      ActivityLog(
        id: '3',
        userId: 'U001',
        userName: 'John Doe',
        action: 'delete',
        module: 'inventory',
        description: 'Removed expired product: Insulin',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        details: {
          'productId': 'P003',
          'name': 'Insulin',
          'reason': 'Expired',
        },
        status: 'success',
      ),
      ActivityLog(
        id: '4',
        userId: 'U003',
        userName: 'Mike Wilson',
        action: 'export',
        module: 'reports',
        description: 'Exported monthly sales report',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        details: {
          'reportType': 'Monthly Sales',
          'period': 'December 2024',
          'format': 'PDF',
        },
        status: 'success',
      ),
      ActivityLog(
        id: '5',
        userId: 'U002',
        userName: 'Jane Smith',
        action: 'update',
        module: 'inventory',
        description: 'Updated stock levels after inventory check',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        details: {
          'productsUpdated': 15,
          'discrepancies': 3,
        },
        status: 'success',
      ),
      ActivityLog(
        id: '6',
        userId: 'U004',
        userName: 'Sarah Brown',
        action: 'create',
        module: 'sales',
        description: 'Created new sale transaction',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        details: {
          'saleId': '1235',
          'amount': 75.25,
          'items': 2,
          'customer': 'Bob Wilson',
        },
        status: 'pending',
      ),
      ActivityLog(
        id: '7',
        userId: 'U001',
        userName: 'John Doe',
        action: 'update',
        module: 'users',
        description: 'Updated user permissions',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        details: {
          'userId': 'U004',
          'permissions': ['sales.create', 'inventory.view'],
        },
        status: 'success',
      ),
      ActivityLog(
        id: '8',
        userId: 'U003',
        userName: 'Mike Wilson',
        action: 'import',
        module: 'inventory',
        description: 'Imported inventory data from CSV',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        details: {
          'recordsImported': 50,
          'errors': 2,
          'source': 'inventory.csv',
        },
        status: 'failed',
      ),
    ];
  }
}
