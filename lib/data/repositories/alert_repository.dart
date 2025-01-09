import 'dart:async';
import 'package:get/get.dart';
import '../../features/alerts_and_notifications/models/notification_model.dart';
import '../../utils/helpers/uuid_generator.dart';
import '../../utils/extensions/getx_extensions.dart';

class AlertRepository extends GetxController {
  final RxList<Notification> _notifications = <Notification>[].obs;
  final RxInt _unreadCount = 0.obs;

  // Stream controller for real-time notifications
  final _notificationController = StreamController<Notification>.broadcast();
  Stream<Notification> get notificationStream => _notificationController.stream;

  // Getters
  List<Notification> get notifications => _notifications;
  int get unreadCount => _unreadCount.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize with some test notifications
    if (Get.isDevelopmentMode) {
      _addTestNotifications();
    }
  }

  @override
  void onClose() {
    _notificationController.close();
    super.onClose();
  }

  Future<void> addNotification(
    String title,
    String message,
    NotificationType type,
    NotificationPriority priority, {
    Map<String, dynamic>? metadata,
  }) async {
    final notification = Notification(
      id: UuidGenerator.generate(),
      title: title,
      message: message,
      type: type,
      priority: priority,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _notifications.insert(0, notification);
    _updateUnreadCount();
    _notificationController.add(notification);

    // Auto-remove low priority notifications after 24 hours
    if (priority == NotificationPriority.low) {
      Timer(const Duration(hours: 24), () {
        removeNotification(notification.id);
      });
    }
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = _notifications[index];
      _notifications[index] = notification.copyWith(isRead: true);
      _updateUnreadCount();
    }
  }

  Future<void> markAllAsRead() async {
    _notifications.value = _notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
    _updateUnreadCount();
  }

  Future<void> removeNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    _updateUnreadCount();
  }

  Future<void> clearAll() async {
    _notifications.clear();
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    _unreadCount.value = _notifications.where((n) => !n.isRead).length;
  }

  Future<List<Notification>> getNotificationsByType(NotificationType type) async {
    return _notifications.where((n) => n.type == type).toList();
  }

  Future<List<Notification>> getNotificationsByPriority(NotificationPriority priority) async {
    return _notifications.where((n) => n.priority == priority).toList();
  }

  void _addTestNotifications() {
    // System notifications
    addNotification(
      'Welcome to Pharmako',
      'Thank you for using Pharmako Pharmacy Management System',
      NotificationType.info,
      NotificationPriority.low,
    );

    addNotification(
      'System Update Available',
      'A new version (2.1.0) is available with improved inventory management',
      NotificationType.systemUpdate,
      NotificationPriority.medium,
      metadata: {
        'version': '2.1.0',
        'releaseNotes': 'https://example.com/release-notes',
      },
    );

    // Security and backup notifications
    addNotification(
      'Security Alert',
      'Multiple failed login attempts detected from IP 192.168.1.100',
      NotificationType.securityAlert,
      NotificationPriority.critical,
      metadata: {
        'ip': '192.168.1.100',
        'attempts': 5,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
      },
    );

    addNotification(
      'Backup Required',
      'Last backup was performed 7 days ago. Please backup your data.',
      NotificationType.backupRequired,
      NotificationPriority.high,
      metadata: {
        'lastBackup': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      },
    );

    // Inventory notifications
    _addLowStockTestNotifications();
    _addExpiryTestNotifications();
    _addPriceChangeTestNotifications();

    // Order notifications
    _addOrderTestNotifications();
  }

  void _addLowStockTestNotifications() {
    final lowStockItems = [
      {
        'name': 'Paracetamol 500mg',
        'currentStock': 20,
        'threshold': 100,
        'category': 'Pain Relief',
        'supplier': 'PharmaCo Ltd',
      },
      {
        'name': 'Amoxicillin 250mg',
        'currentStock': 15,
        'threshold': 50,
        'category': 'Antibiotics',
        'supplier': 'MediSupply Inc',
      },
      {
        'name': 'Insulin Regular',
        'currentStock': 5,
        'threshold': 30,
        'category': 'Diabetes',
        'supplier': 'BioMed Solutions',
      },
    ];

    for (final item in lowStockItems) {
      final stockLevel = (item['currentStock'] as int) / (item['threshold'] as int) * 100;
      final isVeryLow = stockLevel <= 25;

      addNotification(
        'Low Stock Alert: ${item['name']}',
        'Current stock: ${item['currentStock']} units (${stockLevel.toStringAsFixed(0)}% of threshold)',
        NotificationType.warning,
        isVeryLow ? NotificationPriority.high : NotificationPriority.medium,
        metadata: {
          'type': 'low_stock',
          'productName': item['name'],
          'currentStock': item['currentStock'],
          'threshold': item['threshold'],
          'category': item['category'],
          'supplier': item['supplier'],
          'stockLevel': stockLevel,
        },
      );
    }
  }

  void _addExpiryTestNotifications() {
    final expiryItems = [
      {
        'name': 'Amoxicillin 500mg',
        'expiryDate': DateTime.now().add(const Duration(days: 30)),
        'batchNumber': 'BAT2024001',
        'productId': 'AMX500',
      },
      {
        'name': 'Ibuprofen 400mg',
        'expiryDate': DateTime.now().add(const Duration(days: 60)),
        'batchNumber': 'BAT2024002',
        'productId': 'IBU400',
      },
      {
        'name': 'Cetirizine 10mg',
        'expiryDate': DateTime.now().add(const Duration(days: 90)),
        'batchNumber': 'BAT2024003',
        'productId': 'CET10',
      },
    ];

    for (final item in expiryItems) {
      addNotification(
        'Expiring Stock Alert',
        '${item['name']} (Batch #${item['batchNumber']}) will expire on ${(item['expiryDate'] as DateTime).toString().split(' ')[0]}',
        NotificationType.expiringStock,
        NotificationPriority.high,
        metadata: {
          'productId': item['productId'],
          'batchNumber': item['batchNumber'],
          'expiryDate': (item['expiryDate'] as DateTime).toIso8601String(),
        },
      );
    }
  }

  void _addPriceChangeTestNotifications() {
    final priceChanges = [
      {
        'name': 'Aspirin 100mg',
        'oldPrice': 9.99,
        'newPrice': 12.99,
        'productId': 'ASP100',
      },
      {
        'name': 'Vitamin C 1000mg',
        'oldPrice': 15.99,
        'newPrice': 13.99,
        'productId': 'VITC1000',
      },
    ];

    for (final item in priceChanges) {
      final percentageChange = (((item['newPrice'] as double) - (item['oldPrice'] as double)) / (item['oldPrice'] as double) * 100).toStringAsFixed(1);
      final increase = (item['newPrice'] as double) > (item['oldPrice'] as double);

      addNotification(
        'Price Change Alert',
        '${item['name']} price has ${increase ? 'increased' : 'decreased'} by $percentageChange%',
        NotificationType.priceChange,
        NotificationPriority.medium,
        metadata: {
          'productId': item['productId'],
          'oldPrice': item['oldPrice'],
          'newPrice': item['newPrice'],
          'percentageChange': percentageChange,
        },
      );
    }
  }

  void _addOrderTestNotifications() {
    final orders = [
      {
        'orderId': 'ORD2024001',
        'customerName': 'John Doe',
        'items': 3,
        'total': 89.97,
        'status': 'pending',
      },
      {
        'orderId': 'ORD2024002',
        'customerName': 'Jane Smith',
        'items': 5,
        'total': 156.45,
        'status': 'processing',
      },
    ];

    for (final order in orders) {
      addNotification(
        'New Order: #${order['orderId']}',
        'Order received from ${order['customerName']} for ${order['items']} items (Total: \$${(order['total'] as double).toStringAsFixed(2)})',
        NotificationType.newOrder,
        NotificationPriority.high,
        metadata: {
          'orderId': order['orderId'],
          'customerName': order['customerName'],
          'items': order['items'],
          'total': order['total'],
          'status': order['status'],
        },
      );
    }
  }

  // Low stock specific methods
  Future<List<Notification>> getLowStockAlerts() async {
    return _notifications
        .where((n) => n.metadata?['type'] == 'low_stock')
        .toList();
  }

  Future<List<Notification>> getCriticalStockAlerts() async {
    return _notifications
        .where((n) => 
          n.metadata?['type'] == 'low_stock' && 
          (n.metadata?['stockLevel'] as double) <= 25.0)
        .toList();
  }
}
