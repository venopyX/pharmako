import 'package:get/get.dart';
import '../models/dashboard_model.dart';
import '../../../data/services/inventory_service.dart';
import '../../../data/services/alert_service.dart';
import '../../../features/alerts_and_notifications/models/notification_model.dart';

class DashboardController extends GetxController {
  final InventoryService _inventoryService;
  final AlertService _alertService;
  final Rx<DashboardSummary> summary = DashboardSummary().obs;
  final RxList<DashboardChartData> salesData = <DashboardChartData>[].obs;
  final RxList<DashboardAlert> recentAlerts = <DashboardAlert>[].obs;
  final RxBool isLoading = false.obs;

  DashboardController(this._inventoryService, this._alertService);

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      // Load products from inventory service
      final products = await _inventoryService.getProducts();
      final lowStockProducts = products.where((p) => p.isLowStock).toList();
      final expiringProducts = products.where((p) => p.isExpiringSoon).toList();
      
      // Load notifications from alert service
      final alerts = _alertService.notifications;
      final unreadAlerts = alerts.where((n) => !n.isRead).toList();

      // Update summary
      summary.value = DashboardSummary(
        totalProducts: products.length,
        lowStockItems: lowStockProducts.length,
        expiringItems: expiringProducts.length,
        totalSales: products.fold(0.0, (sum, product) => sum + (product.price * product.quantity)),
        pendingAlerts: unreadAlerts.length,
      );

      // Load sales chart data (using dummy data for now)
      salesData.value = [
        DashboardChartData(label: 'Mon', value: 2500),
        DashboardChartData(label: 'Tue', value: 3200),
        DashboardChartData(label: 'Wed', value: 2800),
        DashboardChartData(label: 'Thu', value: 3600),
        DashboardChartData(label: 'Fri', value: 4200),
        DashboardChartData(label: 'Sat', value: 3100),
        DashboardChartData(label: 'Sun', value: 2100),
      ];

      // Load recent alerts from alert service
      recentAlerts.value = alerts.take(5).map((alert) => DashboardAlert(
        title: alert.title,
        message: alert.message,
        type: _mapNotificationTypeToAlertType(alert.type),
        timestamp: alert.timestamp,
      )).toList();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
      );
    } finally {
      isLoading.value = false;
    }
  }

  AlertType _mapNotificationTypeToAlertType(NotificationType type) {
    switch (type) {
      case NotificationType.lowStock:
        return AlertType.lowStock;
      case NotificationType.expiringStock:
        return AlertType.expiring;
      case NotificationType.outOfStock:
        return AlertType.outOfStock;
      case NotificationType.priceChange:
        return AlertType.priceChange;
      case NotificationType.info:
      case NotificationType.warning:
      case NotificationType.systemUpdate:
      case NotificationType.backupRequired:
      case NotificationType.securityAlert:
      case NotificationType.newOrder:
      case NotificationType.paymentDue:
      case NotificationType.custom:
        return AlertType.highDemand; // Default to high demand for other types
    }
  }

  void refreshDashboard() {
    loadDashboardData();
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}