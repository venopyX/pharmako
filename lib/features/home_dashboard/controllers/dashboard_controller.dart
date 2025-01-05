import 'package:get/get.dart';
import '../models/dashboard_model.dart';

class DashboardController extends GetxController {
  final Rx<DashboardSummary> summary = DashboardSummary().obs;
  final RxList<DashboardChartData> salesData = <DashboardChartData>[].obs;
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
      summary.value = DashboardSummary(
        totalProducts: 150,
        lowStockItems: 12,
        expiringItems: 8,
        totalSales: 25000.0,
        pendingAlerts: 5,
      );

      salesData.value = [
        DashboardChartData(label: 'Mon', value: 2500),
        DashboardChartData(label: 'Tue', value: 3200),
        DashboardChartData(label: 'Wed', value: 2800),
        DashboardChartData(label: 'Thu', value: 3600),
        DashboardChartData(label: 'Fri', value: 4200),
        DashboardChartData(label: 'Sat', value: 3100),
        DashboardChartData(label: 'Sun', value: 2100),
      ];
    } catch (e) {
      // TODO: Implement error handling
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshDashboard() {
    loadDashboardData();
  }
}