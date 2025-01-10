import 'package:get/get.dart';
import '../data/repositories/analytics_repository.dart';
import '../data/services/analytics_service.dart';
import '../features/reports_and_analytics/controllers/analytics_report_controller.dart';

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

    // Controller
    Get.lazyPut<AnalyticsReportController>(
      () => AnalyticsReportController(Get.find<AnalyticsService>()),
    );
  }
}
