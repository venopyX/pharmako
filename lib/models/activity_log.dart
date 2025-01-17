/// Model class representing an activity log entry
class ActivityLog {
  final String id;
  final String userId;
  final String userName;
  final String action; // e.g., 'create', 'update', 'delete', 'view', 'export'
  final String module; // e.g., 'inventory', 'sales', 'users', 'reports'
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? details;
  final String? ipAddress;
  final String status; // 'success', 'failed', 'pending'

  const ActivityLog({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.module,
    required this.description,
    required this.timestamp,
    this.details,
    this.ipAddress,
    this.status = 'success',
  });

  /// Create a copy of this activity log with updated fields
  ActivityLog copyWith({
    String? id,
    String? userId,
    String? userName,
    String? action,
    String? module,
    String? description,
    DateTime? timestamp,
    Map<String, dynamic>? details,
    String? ipAddress,
    String? status,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      action: action ?? this.action,
      module: module ?? this.module,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      status: status ?? this.status,
    );
  }

  /// Convert activity log to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'action': action,
      'module': module,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
      'ipAddress': ipAddress,
      'status': status,
    };
  }

  /// Create activity log from JSON
  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      action: json['action'] as String,
      module: json['module'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: json['details'] as Map<String, dynamic>?,
      ipAddress: json['ipAddress'] as String?,
      status: json['status'] as String,
    );
  }

  /// Get the icon for this activity based on the action
  String get actionIcon {
    switch (action.toLowerCase()) {
      case 'create':
        return '➕';
      case 'update':
        return '✏️';
      case 'delete':
        return '🗑️';
      case 'view':
        return '👁️';
      case 'export':
        return '📤';
      case 'import':
        return '📥';
      case 'login':
        return '🔑';
      case 'logout':
        return '🔒';
      default:
        return '📝';
    }
  }

  /// Get the color for this activity based on the status
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'success':
        return 'green';
      case 'failed':
        return 'red';
      case 'pending':
        return 'orange';
      default:
        return 'grey';
    }
  }
}
