import 'dart:async';
import 'package:get/get.dart';
import '../../features/alerts_and_notifications/models/notification_model.dart';
import '../../utils/helpers/uuid_generator.dart';

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
      id: generateUuid(),
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
    addNotification(
      'Low Stock Alert',
      'Paracetamol stock is running low (10 units remaining)',
      NotificationType.lowStock,
      NotificationPriority.high,
      metadata: {'productId': '123', 'currentStock': 10},
    );

    addNotification(
      'Expiring Stock',
      'Amoxicillin batch #456 will expire in 30 days',
      NotificationType.expiringStock,
      NotificationPriority.medium,
      metadata: {'productId': '456', 'expiryDate': DateTime.now().add(const Duration(days: 30)).toIso8601String()},
    );

    addNotification(
      'System Update',
      'New version available: v2.0.1',
      NotificationType.systemUpdate,
      NotificationPriority.low,
    );
  }
}
