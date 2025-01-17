import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/notification.dart';
import '../services/sample_data_service.dart';

/// Controller for managing in-app notifications
class NotificationManagementController extends GetxController {
  final _logger = Logger();

  // Observable states
  final notifications = <Notification>[].obs;
  final isLoading = false.obs;
  final currentFilter = 'all'.obs;
  final sortOrder = 'newest'.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  /// Load notifications from the service
  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      _logger.i('Loading notifications...');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      notifications.value = SampleDataService.getSampleNotifications();
      _logger.i('Loaded ${notifications.length} notifications');
    } catch (e, stackTrace) {
      _logger.e('Failed to load notifications', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load notifications',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  /// Get unread notifications count
  int get unreadCount => notifications
      .where((notification) => !notification.isRead)
      .length;

  /// Get filtered notifications based on current filter and sort order
  List<Notification> get filteredNotifications {
    var filtered = <Notification>[];

    // Apply filter
    switch (currentFilter.value) {
      case 'unread':
        filtered = notifications.where((n) => !n.isRead).toList();
        break;
      case 'inventory':
        filtered = notifications.where((n) => n.type == 'inventory').toList();
        break;
      case 'sales':
        filtered = notifications.where((n) => n.type == 'sales').toList();
        break;
      case 'system':
        filtered = notifications.where((n) => n.type == 'system').toList();
        break;
      case 'reports':
        filtered = notifications.where((n) => n.type == 'reports').toList();
        break;
      default:
        filtered = notifications.toList();
    }

    // Apply sort
    switch (sortOrder.value) {
      case 'oldest':
        filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'priority':
        filtered.sort((a, b) {
          final priorityOrder = {'high': 0, 'normal': 1, 'low': 2};
          return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
        });
        break;
      default: // newest
        filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    return filtered;
  }

  /// Set the current filter
  void setFilter(String filter) {
    currentFilter.value = filter;
  }

  /// Set the sort order
  void setSortOrder(String order) {
    sortOrder.value = order;
  }

  /// Mark a notification as read
  void markAsRead(String id) {
    try {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final notification = notifications[index];
        notifications[index] = notification.copyWith(isRead: true);
        notifications.refresh();
        _logger.i('Marked notification $id as read');
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to mark notification as read', error: e, stackTrace: stackTrace);
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    try {
      final updated = notifications.map((n) => n.copyWith(isRead: true)).toList();
      notifications.value = updated;
      _logger.i('Marked all notifications as read');
    } catch (e, stackTrace) {
      _logger.e('Failed to mark all notifications as read', error: e, stackTrace: stackTrace);
    }
  }

  /// Remove a notification
  void removeNotification(String id) {
    try {
      notifications.removeWhere((n) => n.id == id);
      _logger.i('Removed notification $id');
    } catch (e, stackTrace) {
      _logger.e('Failed to remove notification', error: e, stackTrace: stackTrace);
    }
  }

  /// Clear all notifications
  void clearAll() {
    try {
      notifications.clear();
      _logger.i('Cleared all notifications');
    } catch (e, stackTrace) {
      _logger.e('Failed to clear notifications', error: e, stackTrace: stackTrace);
    }
  }

  /// Handle notification tap
  void onNotificationTap(Notification notification) {
    markAsRead(notification.id);
    if (notification.actionRoute != null) {
      Get.toNamed(notification.actionRoute!);
    }
  }
}
