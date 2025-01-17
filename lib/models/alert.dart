import 'package:flutter/material.dart';

/// Enum representing different types of alerts
enum AlertType {
  /// Success alerts (green)
  success,
  /// Warning alerts (orange)
  warning,
  /// Danger alerts (red)
  danger,
  /// Info alerts (blue)
  info,
}

/// Model class representing an alert
class Alert {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;
  final bool isRead;

  /// Creates a new alert instance
  const Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  /// Get the icon for this alert type
  IconData get icon {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.danger:
        return Icons.error;
      case AlertType.info:
        return Icons.info;
    }
  }

  /// Get the color for this alert type
  Color get color {
    switch (type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.danger:
        return Colors.red;
      case AlertType.info:
        return Colors.blue;
    }
  }

  /// Creates a copy of this alert with the given fields replaced with new values
  Alert copyWith({
    String? id,
    String? title,
    String? message,
    AlertType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  /// Converts this alert to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  /// Creates an alert from a JSON map
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: AlertType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AlertType.info,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] ?? false,
    );
  }
}
