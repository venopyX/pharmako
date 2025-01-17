/// Model class representing an in-app notification
class Notification {
  final String id;
  final String title;
  final String message;
  final String type; // inventory, sales, system, reports
  final DateTime timestamp;
  final bool isRead;
  final String? actionRoute; // Route to navigate when clicked
  final Map<String, dynamic>? metadata;
  final String priority; // high, normal, low

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
    this.metadata,
    this.priority = 'normal',
  });

  /// Create a copy of this notification with updated fields
  Notification copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? actionRoute,
    Map<String, dynamic>? metadata,
    String? priority,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      metadata: metadata ?? this.metadata,
      priority: priority ?? this.priority,
    );
  }

  /// Convert notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionRoute': actionRoute,
      'metadata': metadata,
      'priority': priority,
    };
  }

  /// Create notification from JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool,
      actionRoute: json['actionRoute'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      priority: json['priority'] as String,
    );
  }
}
