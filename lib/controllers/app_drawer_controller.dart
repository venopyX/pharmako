import 'package:get/get.dart';
import '../services/activity_log_service.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';

/// Controller for managing the app drawer functionality
class AppDrawerController extends GetxController {
  final _activityLogService = Get.find<ActivityLogService>();
  final _notificationService = Get.find<NotificationService>();
  final _authService = Get.find<AuthService>();

  // Observable values
  final notifications = 0.obs;
  final userName = ''.obs;
  final userRole = ''.obs;
  final userAvatar = ''.obs;
  final pharmacyName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _loadNotifications();
    _setupListeners();
  }

  /// Load user information
  void _loadUserInfo() {
    try {
      final user = _authService.currentUser.value;
      if (user != null) {
        userName.value = user.name;
        userRole.value = user.role;
        userAvatar.value = user.avatarUrl;
        pharmacyName.value = user.pharmacyName;
      }
    } catch (e) {
      // Set default values if there's an error
      userName.value = 'Guest User';
      userRole.value = 'Guest';
      userAvatar.value = 'https://via.placeholder.com/150';
      pharmacyName.value = 'Pharmacy';
    }
  }

  /// Load notifications count
  void _loadNotifications() {
    try {
      notifications.value = _notificationService.unreadCount;
    } catch (e) {
      notifications.value = 0;
    }
  }

  /// Setup listeners for real-time updates
  void _setupListeners() {
    ever(_notificationService.unreadNotifications, (count) {
      notifications.value = count;
    });

    ever(_authService.currentUser, (user) {
      if (user != null) {
        _loadUserInfo();
      }
    });
  }

  /// Log navigation events
  void logNavigation(String screen) {
    _activityLogService.log('User navigated to $screen screen');
  }
}
