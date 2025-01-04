import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/logging/logger.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Login method
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle errors here, e.g., wrong password, user not found, etc.
      TLoggerHelper.error('Login failed: ${e.message}');
      return null;
    }
  }

  // Logout method
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Register method
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle errors here, e.g., weak password, email already in use, etc.
      TLoggerHelper.error('Registration failed: ${e.message}');
      return null;
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Handle errors here, e.g., user not found, etc.
      TLoggerHelper.error('Password reset email failed: ${e.message}');
    }
  }
}
