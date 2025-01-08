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
    // Add existing test notifications
    addNotification(
      'Welcome to Pharmako',
      'Thank you for using Pharmako Pharmacy Management System',
      NotificationType.info,
      NotificationPriority.low,
    );

    // Add low stock test notifications
    _addLowStockTestNotifications();
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
