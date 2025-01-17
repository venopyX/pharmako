import 'package:get/get.dart';

/// Service for managing authentication
class AuthService extends GetxService {
  final isAuthenticated = false.obs;
  final currentUser = Rxn<User>();

  /// Login user
  Future<bool> login(String username, String password) async {
    try {
      // TODO: Implement login with backend
      isAuthenticated.value = true;
      currentUser.value = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'admin',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    // TODO: Implement logout with backend
    isAuthenticated.value = false;
    currentUser.value = null;
  }

  /// Check if user is logged in
  bool get isLoggedIn => isAuthenticated.value;

  /// Get current user
  User? get user => currentUser.value;
}

/// User model
class User {
  final String id;
  final String name;
  final String email;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}
