import 'package:get/get.dart';
import '../models/alert.dart';

/// Service for managing notifications
class NotificationService extends GetxService {
  final notifications = <Alert>[].obs;

  /// Add a new notification
  void addNotification(Alert notification) {
    notifications.add(notification);
    // TODO: Implement push notification
  }

  /// Mark a notification as read
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = notification.copyWith(isRead: true);
    }
  }

  /// Clear all notifications
  void clearAll() {
    notifications.clear();
  }

  /// Get the count of unread notifications
  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
