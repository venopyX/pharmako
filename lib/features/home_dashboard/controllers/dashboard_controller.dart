import 'package:get/get.dart';
import '../models/dashboard_model.dart';

class DashboardController extends GetxController {
  final Rx<DashboardSummary> summary = DashboardSummary().obs;
  final RxList<DashboardChartData> salesData = <DashboardChartData>[].obs;
  final RxList<DashboardAlert> recentAlerts = <DashboardAlert>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      // Simulated data for now
      await Future.delayed(const Duration(seconds: 1));
      
      // Load summary data
      summary.value = DashboardSummary(
        totalProducts: 150,
        lowStockItems: 12,
        expiringItems: 8,
        totalSales: 25000.0,
        pendingAlerts: 5,
      );

      // Load sales chart data
      salesData.value = [
        DashboardChartData(label: 'Mon', value: 2500),
        DashboardChartData(label: 'Tue', value: 3200),
        DashboardChartData(label: 'Wed', value: 2800),
        DashboardChartData(label: 'Thu', value: 3600),
        DashboardChartData(label: 'Fri', value: 4200),
        DashboardChartData(label: 'Sat', value: 3100),
        DashboardChartData(label: 'Sun', value: 2100),
      ];

      // Load recent alerts
      recentAlerts.value = [
        DashboardAlert(
          title: 'Low Stock Alert',
          message: 'Paracetamol is running low',
          type: AlertType.lowStock,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        DashboardAlert(
          title: 'Expiring Stock Alert',
          message: 'Amoxicillin batch #123 expires in 30 days',
          type: AlertType.expiring,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        DashboardAlert(
          title: 'High Demand Alert',
          message: 'Vitamin C sales increased by 50%',
          type: AlertType.highDemand,
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ];
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