// TODO: Define the data model for notifications.

import 'package:flutter/material.dart';

enum NotificationType {
  info,
  warning,
  lowStock,
  expiringStock,
  outOfStock,
  priceChange,
  systemUpdate,
  backupRequired,
  securityAlert,
  newOrder,
  paymentDue,
  custom
}

enum NotificationPriority {
  low,
  medium,
  high,
  critical
}

class Notification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
  });

  Color get color {
    switch (type) {
      case NotificationType.lowStock:
      case NotificationType.outOfStock:
        return Colors.orange;
      case NotificationType.expiringStock:
        return Colors.red;
      case NotificationType.priceChange:
        return Colors.blue;
      case NotificationType.systemUpdate:
        return Colors.green;
      case NotificationType.backupRequired:
        return Colors.purple;
      case NotificationType.securityAlert:
        return Colors.red.shade700;
      case NotificationType.newOrder:
        return Colors.blue.shade700;
      case NotificationType.paymentDue:
        return Colors.amber.shade700;
      case NotificationType.custom:
        return Colors.grey;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.warning:
        return Colors.amber;
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.lowStock:
        return Icons.inventory_2;
      case NotificationType.outOfStock:
        return Icons.remove_shopping_cart;
      case NotificationType.expiringStock:
        return Icons.timer;
      case NotificationType.priceChange:
        return Icons.attach_money;
      case NotificationType.systemUpdate:
        return Icons.system_update;
      case NotificationType.backupRequired:
        return Icons.backup;
      case NotificationType.securityAlert:
        return Icons.security;
      case NotificationType.newOrder:
        return Icons.shopping_cart;
      case NotificationType.paymentDue:
        return Icons.payment;
      case NotificationType.custom:
        return Icons.notifications;
      case NotificationType.info:
        return Icons.info;
      case NotificationType.warning:
        return Icons.warning;
    }
  }

  String get priorityText {
    switch (priority) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.medium:
        return 'Medium';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.critical:
        return 'Critical';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case NotificationPriority.low:
        return Colors.green;
      case NotificationPriority.medium:
        return Colors.orange;
      case NotificationPriority.high:
        return Colors.red;
      case NotificationPriority.critical:
        return Colors.red.shade900;
    }
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString() == 'NotificationPriority.${json['priority']}',
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      if (metadata != null) 'metadata': metadata,
    };
  }

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }
}
