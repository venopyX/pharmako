import 'package:get/get.dart';
import '../services/activity_log_service.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';

/// Controller for managing the main menu functionality
class MainMenuController extends GetxController {
  final _activityLogService = Get.find<ActivityLogService>();
  final _notificationService = Get.find<NotificationService>();
  final _authService = Get.find<AuthService>();

  // Observable values
  final notifications = 0.obs;
  final userName = ''.obs;
  final userInitials = ''.obs;
  final lowStockCount = 0.obs;
  final expiringCount = 0.obs;
  final totalItemsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _loadNotifications();
    _loadQuickStats();
  }

  /// Load user information
  void _loadUserInfo() {
    final user = _authService.currentUser.value;
    if (user != null) {
      userName.value = user.name;
      userInitials.value = user.name
          .split(' ')
          .map((e) => e.isNotEmpty ? e[0] : '')
          .take(2)
          .join()
          .toUpperCase();
    }
  }

  /// Load notifications count
  void _loadNotifications() {
    notifications.value = _notificationService.unreadCount;
  }

  /// Load quick stats
  void _loadQuickStats() {
    // TODO: Implement inventory service to get these values
    lowStockCount.value = 12;
    expiringCount.value = 8;
    totalItemsCount.value = 486;
  }

  /// Navigate to notifications screen
  void goToNotifications() {
    _activityLogService.log('User navigated to notifications screen');
    Get.toNamed('/notifications');
  }

  /// Navigate to profile screen
  void goToProfile() {
    _activityLogService.log('User navigated to profile screen');
    Get.toNamed('/profile');
  }

  /// Navigate to inventory screen
  void goToInventory() {
    _activityLogService.log('User navigated to inventory screen');
    Get.toNamed('/inventory');
  }

  /// Navigate to sales screen
  void goToSales() {
    _activityLogService.log('User navigated to sales screen');
    Get.toNamed('/sales');
  }

  /// Navigate to analytics screen
  void goToAnalytics() {
    _activityLogService.log('User navigated to analytics screen');
    Get.toNamed('/analytics');
  }

  /// Navigate to orders screen
  void goToOrders() {
    _activityLogService.log('User navigated to orders screen');
    Get.toNamed('/orders');
  }

  /// Handle search query
  void handleSearch(String query) {
    if (query.isEmpty) return;
    
    _activityLogService.log('User searched for: $query');
    
    // TODO: Implement search functionality
    Get.toNamed('/search', arguments: {'query': query});
  }
}
