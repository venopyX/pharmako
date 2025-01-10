import 'package:get/get.dart';
import '../data/repositories/analytics_repository.dart';
import '../data/services/analytics_service.dart';
import '../features/reports_and_analytics/controllers/dashboard_analytics_controller.dart';
import '../features/reports_and_analytics/controllers/inventory_analytics_controller.dart';
import '../features/reports_and_analytics/controllers/sales_analytics_controller.dart';
import '../features/reports_and_analytics/controllers/inventory_report_controller.dart';
import '../features/reports_and_analytics/controllers/customer_analytics_controller.dart';
import '../features/reports_and_analytics/controllers/order_analytics_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<AnalyticsRepository>(
      () => AnalyticsRepository(),
    );

    // Service
    Get.lazyPut<AnalyticsService>(
      () => AnalyticsService(Get.find<AnalyticsRepository>()),
    );

    // Controllers
    Get.lazyPut<DashboardAnalyticsController>(
      () => DashboardAnalyticsController(Get.find<AnalyticsService>()),
    );

    Get.lazyPut<InventoryAnalyticsController>(
      () => InventoryAnalyticsController(Get.find<AnalyticsService>()),
    );

    Get.lazyPut<SalesAnalyticsController>(
      () => SalesAnalyticsController(Get.find<AnalyticsService>()),
    );

    Get.lazyPut<InventoryReportController>(
      () => InventoryReportController(Get.find<AnalyticsService>()),
    );

    Get.lazyPut<CustomerAnalyticsController>(
      () => CustomerAnalyticsController(Get.find<AnalyticsService>()),
    );

    Get.lazyPut<OrderAnalyticsController>(
      () => OrderAnalyticsController(Get.find<AnalyticsService>()),
    );
  }
}
