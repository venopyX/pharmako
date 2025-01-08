import 'dart:async';
import 'package:get/get.dart';
import '../../../data/services/alert_service.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final AlertService _alertService;
  final RxList<Notification> notifications = <Notification>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedType = ''.obs;
  final RxString selectedPriority = ''.obs;
  StreamSubscription<Notification>? _notificationSubscription;

  NotificationController(this._alertService);

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    _subscribeToNotifications();
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    super.onClose();
  }

  Future<void> initializeNotifications() async {
    isLoading.value = true;
    notifications.value = _alertService.notifications;
    unreadCount.value = _alertService.unreadCount;
    isLoading.value = false;
  }

  void _subscribeToNotifications() {
    _notificationSubscription = _alertService.notificationStream.listen((notification) {
      notifications.insert(0, notification);
      if (!notification.isRead) {
        unreadCount.value++;
      }
    });
  }

  Future<void> markAsRead(String id) async {
    await _alertService.markAsRead(id);
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = notifications[index];
      if (!notification.isRead) {
        notifications[index] = notification.copyWith(isRead: true);
        unreadCount.value--;
      }
    }
  }

  Future<void> markAllAsRead() async {
    await _alertService.markAllAsRead();
    notifications.value = notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
    unreadCount.value = 0;
  }

  Future<void> removeNotification(String id) async {
    await _alertService.removeNotification(id);
    final notification = notifications.firstWhereOrNull((n) => n.id == id);
    if (notification != null && !notification.isRead) {
      unreadCount.value--;
    }
    notifications.removeWhere((n) => n.id == id);
  }

  Future<void> clearAll() async {
    await _alertService.clearAll();
    notifications.clear();
    unreadCount.value = 0;
  }

  Future<void> filterByType(NotificationType? type) async {
    if (type == null) {
      selectedType.value = '';
      initializeNotifications();
      return;
    }

    selectedType.value = type.toString();
    isLoading.value = true;
    final filtered = await _alertService.getNotificationsByType(type);
    notifications.value = filtered;
    isLoading.value = false;
  }

  Future<void> filterByPriority(NotificationPriority? priority) async {
    if (priority == null) {
      selectedPriority.value = '';
      initializeNotifications();
      return;
    }

    selectedPriority.value = priority.toString();
    isLoading.value = true;
    final filtered = await _alertService.getNotificationsByPriority(priority);
    notifications.value = filtered;
    isLoading.value = false;
  }

  // Low stock specific methods
  Future<List<Notification>> getLowStockAlerts() async {
    return _alertService.getLowStockAlerts();
  }

  Future<List<Notification>> getCriticalStockAlerts() async {
    return _alertService.getCriticalStockAlerts();
  }

  Future<void> addLowStockAlert({
    required String productName,
    required int currentStock,
    required int threshold,
    required String category,
    required String supplier,
  }) async {
    await _alertService.addLowStockAlert(
      productName: productName,
      currentStock: currentStock,
      threshold: threshold,
      category: category,
      supplier: supplier,
    );
  }

  Future<void> addExpiryAlert(String productName, DateTime expiryDate, String productId, String batchNumber) async {
    await _alertService.addExpiryAlert(productName, expiryDate, productId, batchNumber);
  }

  Future<void> addOutOfStockAlert(String productName, String productId) async {
    await _alertService.addOutOfStockAlert(productName, productId);
  }

  Future<void> addPriceChangeAlert(String productName, double oldPrice, double newPrice, String productId) async {
    await _alertService.addPriceChangeAlert(productName, oldPrice, newPrice, productId);
  }

  Future<void> addSecurityAlert(String title, String message, {Map<String, dynamic>? metadata}) async {
    await _alertService.addSecurityAlert(title, message, metadata: metadata);
  }

  Future<void> addBackupAlert(String message, {Map<String, dynamic>? metadata}) async {
    await _alertService.addBackupAlert(message, metadata: metadata);
  }
}
