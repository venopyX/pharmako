import 'dart:async';
import '../../features/alerts_and_notifications/models/notification_model.dart';
import '../repositories/alert_repository.dart';

class AlertService {
  final AlertRepository _repository;

  AlertService(this._repository);

  // Stream access
  Stream<Notification> get notificationStream => _repository.notificationStream;

  // Getters
  List<Notification> get notifications => _repository.notifications;
  int get unreadCount => _repository.unreadCount;

  // Core notification methods
  Future<void> addNotification(
    String title,
    String message,
    NotificationType type,
    NotificationPriority priority, {
    Map<String, dynamic>? metadata,
  }) async {
    await _repository.addNotification(
      title,
      message,
      type,
      priority,
      metadata: metadata,
    );
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
  }

  Future<void> removeNotification(String id) async {
    await _repository.removeNotification(id);
  }

  Future<void> clearAll() async {
    await _repository.clearAll();
  }

  // Query methods
  Future<List<Notification>> getNotificationsByType(NotificationType type) async {
    return _repository.getNotificationsByType(type);
  }

  Future<List<Notification>> getNotificationsByPriority(NotificationPriority priority) async {
    return _repository.getNotificationsByPriority(priority);
  }

  // Convenience methods for common notifications
  Future<void> addLowStockAlert(String productName, int currentStock, String productId) async {
    await addNotification(
      'Low Stock Alert',
      '$productName stock is running low ($currentStock units remaining)',
      NotificationType.lowStock,
      NotificationPriority.high,
      metadata: {
        'productId': productId,
        'currentStock': currentStock,
      },
    );
  }

  Future<void> addExpiryAlert(String productName, DateTime expiryDate, String productId, String batchNumber) async {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    
    NotificationPriority priority;
    if (daysUntilExpiry <= 30) {
      priority = NotificationPriority.critical;
    } else if (daysUntilExpiry <= 60) {
      priority = NotificationPriority.high;
    } else if (daysUntilExpiry <= 90) {
      priority = NotificationPriority.medium;
    } else {
      priority = NotificationPriority.low;
    }

    await addNotification(
      'Expiring Stock',
      '$productName (Batch #$batchNumber) will expire in $daysUntilExpiry days',
      NotificationType.expiringStock,
      priority,
      metadata: {
        'productId': productId,
        'batchNumber': batchNumber,
        'expiryDate': expiryDate.toIso8601String(),
      },
    );
  }

  Future<void> addOutOfStockAlert(String productName, String productId) async {
    await addNotification(
      'Out of Stock Alert',
      '$productName is now out of stock',
      NotificationType.outOfStock,
      NotificationPriority.critical,
      metadata: {
        'productId': productId,
      },
    );
  }

  Future<void> addPriceChangeAlert(String productName, double oldPrice, double newPrice, String productId) async {
    final percentageChange = ((newPrice - oldPrice) / oldPrice * 100).toStringAsFixed(1);
    final increase = newPrice > oldPrice;

    await addNotification(
      'Price Change',
      '$productName price has ${increase ? 'increased' : 'decreased'} by $percentageChange%',
      NotificationType.priceChange,
      NotificationPriority.medium,
      metadata: {
        'productId': productId,
        'oldPrice': oldPrice,
        'newPrice': newPrice,
        'percentageChange': percentageChange,
      },
    );
  }

  Future<void> addSecurityAlert(String title, String message, {Map<String, dynamic>? metadata}) async {
    await addNotification(
      title,
      message,
      NotificationType.securityAlert,
      NotificationPriority.critical,
      metadata: metadata,
    );
  }

  Future<void> addBackupAlert(String message, {Map<String, dynamic>? metadata}) async {
    await addNotification(
      'Backup Required',
      message,
      NotificationType.backupRequired,
      NotificationPriority.high,
      metadata: metadata,
    );
  }
}
