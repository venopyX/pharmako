/// Model class representing a user profile in the system
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? photoUrl;
  final Map<String, dynamic> preferences;
  final Map<String, bool> permissions;
  final DateTime lastLogin;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
    required this.preferences,
    required this.permissions,
    required this.lastLogin,
    required this.createdAt,
  });

  /// Create a copy of this user profile with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? photoUrl,
    Map<String, dynamic>? preferences,
    Map<String, bool>? permissions,
    DateTime? lastLogin,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      preferences: preferences ?? this.preferences,
      permissions: permissions ?? this.permissions,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert user profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'preferences': preferences,
      'permissions': permissions,
      'lastLogin': lastLogin.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create user profile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      photoUrl: json['photoUrl'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>,
      permissions: Map<String, bool>.from(json['permissions'] as Map),
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Default preferences for a new user
  static Map<String, dynamic> get defaultPreferences => {
    'theme': 'light',
    'language': 'en',
    'timezone': 'UTC+3',
    'currency': 'USD',
    'dateFormat': 'MM/dd/yyyy',
    'timeFormat': '12h',
    'notifications': {
      'email': true,
      'push': true,
      'sms': false,
    },
    'display': {
      'compactMode': false,
      'highContrast': false,
      'fontSize': 'medium',
      'animations': true,
    },
  };

  /// Default permissions for a new user
  static Map<String, bool> get defaultPermissions => {
    'inventory.view': true,
    'inventory.edit': false,
    'sales.view': true,
    'sales.edit': false,
    'reports.view': true,
    'reports.edit': false,
    'users.view': false,
    'users.edit': false,
    'settings.view': true,
    'settings.edit': false,
  };
}
